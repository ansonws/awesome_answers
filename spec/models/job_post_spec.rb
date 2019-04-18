require 'rails_helper'

# To run your tests with rspec, do:
# > rspec

# To get detailed information about running the tests, do:
# > rspec -f d
RSpec.describe JobPost, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  def job_post
    # @job_post ||= JobPost.new(
    #   title: "Awesome Job",
    #   description: "Some valid job description"
    # )
    @job_post ||= FactoryBot.build :job_post
  end
  # The "describe" is used to group related tests together. 
  # It is primarily used as an organizational tool.
  # All of the grouped tests should be written inside the block of the method.
  describe "validates" do
    it "requires a title" do 
      # GIVEN an instance of a JobPost (without a title)
      # job_post = JobPost.new
      jp = job_post
      jp.title = nil

      # WHEN validations are triggered (or WHEN we attempt to save the JobPost)
      job_post.valid? 

      # THEN there's an error related to title in the errors object.
      # The following will pass the test if the errors.messages hash has a key named :title. 
      # This only occurs if a 'title' validation fails.
      expect(job_post.errors.messages).to have_key(:title)
    end

    it 'requires a unique title' do
      # GIVEN one job post in the db and one instance of job post with the same title:
      persisted_jp = JobPost.create title: "Full Stack Developer"
      jp = JobPost.new(title: persisted_jp.title)

      # WHEN 
      jp.valid?

      # THEN
      expect(jp.errors.messages).to(have_key(:title))
      expect(jp.errors.messages[:title]).to(include("has already been taken"))
      # # To get a list of all possible matchers for tests go to:
      # https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end

    # As per ruby docs, methods that are described with a '.' are class methods. Those that are described with a '#' in front are instance methods.
    describe ".search" do
      it "returns only job posts containing the search term, regardless of case" do
        # GIVEN
        # 3 job posts in database
        job_post_a = FactoryBot.create(
          :job_post,
          title: "Software Engineer"
        )
        job_post_b = FactoryBot.create(
          :job_post,
          title: "Programmer"
        )
        job_post_c = FactoryBot.create(
          :job_post,
          title: "Software Architect"
        )

        # WHEN
          # We search for 'software's
          results = JobPost.search 'software'

        # THEN
        # JobPost A & C are returned
        expect(results).to(eq([job_post_a, job_post_c]))
      end
    end
  end
end
