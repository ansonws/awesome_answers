require 'rails_helper'

RSpec.describe JobPostsController, type: :controller do
    def current_user
        @current_user ||= FactoryBot.create :user
    end
    describe "#new" do
        context "with signed in user" do
            # Use 'before' to run a block of code before all tests inside of a block. In this case, the following block will be run before the two tests inside this context's block.
            before do
                current_user
            end
            
            it "renders a new template" do
                # GIVEN Defaults

                # WHEN Making a GET request to the new action
                # When testing controllers, use methods named after HTTP verbs (e.g. get, post, patch, put, delete) to simulate HTTP requests to your conroller actions
                # Example:
                get :new # This simulates a GET to JobPostsController's new action

                # THEN
                # The `response` contains the rendered template of `new`

                # The `response` object is available inside any controller test:
                # test. `flash` & `session` objects are also available inside of your controller tests.
                expect(response).to(render_template(:new))
            end

            it "sets an instance variable of a new job post" do
                get :new

                # assigns :job_post
                # returns the value of the instance variable named after the symbol argument e.g. :job_post --> @job_post
                # Only available with the gem "rails-controller-testing"

                expect(assigns(:job_post)).to(be_a_new(JobPost))
                # The above matcher will verify that the expected value is a new instance of the JobPost model
            end
        end

        context "without a signed in user" do
            it "redirects the user to session new" do
                get :new
                expect(response).to redirect_to(new_session_path)
            end

            it "sets a danger flash message" do
                get :new
                expect(flash[:danger]).to be
            end
        end
    end

    describe "#create" do
    def valid_request
        post :create, params: { job_post: FactoryBot.attributes_for :job_post }
    end
        context "with signed in user" do
            # `context` is functionally the same as `describe`, but we use it instead to seperate branching code.
            context "with valid parameters" do
                it "creates a new job post" do
                    # GIVEN no JobPost records in the db
                    count_before = JobPost.count

                    # WHEN we make a post to create with valid job post params
                    valid_request

                    # THEN There is one more Job Post in the db
                    count_after = JobPost.count
                    expect(count_after).to eq(count_before + 1)

                end

                it "redirects to the show page of that post" do
                    valid_request
            
                    job_post = JobPost.last
                    expect(response).to(redirect_to(job_post_url(job_post.id)))
                end
            end

            context "with invalid parameters" do
                it "doesn't create a job post" do
                    count_before = JobPost.count
                    post(
                        :create,
                        params: {
                            job_post: FactoryBot.attributes_for :job_post, title: nil
                        }
                    )
                    count_after = JobPost.count

                    expect(count_after).to(eq(count_before))
                end

                it "renders the new template" do

                end

                it "assigns an invalid job post as an instance variable" do

                end
            end
        end

        context "without signed in user" do
            it "redirects to the new session path" do
                valid_request
                
            end
        end
    end

    describe "destroy" do
        context "without signed in user" do
            it "redirects to the new session path" do
                job_post = FactoryBot.create(:job_post)
                delete(:destroy, params: { id: job_post.id })
                expect(response).to redirect_to(new_session_path)
            end
        end

        context "with signed in user" do
            before do
                session[:user_id] = current_user.id
            end
            context "as non-owner" do
                it "doesn't remove the job post" do
                    job_post = FactoryBot.create :job_post
                    delete(:destroy, params: { id: job_post.id })
                    expect(JobPost.find_by(id: job_post.id)).to(eq(job_post))
                end
                it "redirects to the job post show" do
                    job_post = FactoryBot.create :job_post
                    delete(:destroy, params: { id: job_post.id })
                    expect(JobPost.find_by(id: job_post.id)).to(eq(job_post))
                end

            end
            context "as owner" do
                it "destroys the job post from the db" do
                    
                end

                it "redirects to the job post show" do
                    
                end
            end
        end
    end
end
