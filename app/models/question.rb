class Question < ApplicationRecord
    # This is the Question model. We generate this file with the command:
    # > rails generate model question title:string body:text
    # This command also generates a migration file in db/migrate

    # Rails will automatically add attr_accessors for all of the columns of the table (i.e. title body, created_at, updated_at)

    # Adding the 'dependent: :destroy' option tells Rails to delete associated records before deleting the record itself. In this case specifically, when a question is deleted, its answers are deleted first to satisfy the foreign key constraint.
    # You can also use dependent: :nullify, which will cause all associated answers to have their question_id column set to NULL before the question is destroyed. 
    # If you don't set either dependent option you can end up with answers in your db referencing question_ids that no longer exist.
    # Always set a dependent option to help maintain referential integrity.
    has_many :answers, dependent: :destroy
    # 'has_many :answers' adds the following instance methods to the Question model:

    # answers => Returns an ActiveRecord array
    # answers<<(object, ...)
    # answers.delete(object, ...)
    # answers.destroy(object, ...)
    # answers=(objects)
    # answers_singular_ids
    # answers_singular_ids=(ids)
    # answers.clear
    # answers.empty?
    # answers.size
    # answers.find(...)
    # answers.where(...)
    # answers.exists?(...)
    # answers.build(attributes = {}, ...)
    # answers.create(attributes = {})
    # answers.create!(attributes = {})
    # answers.reload

    # Create validations by using the 'validates' method. The arguments are (in order):
    # - A column name as a symbol
    # - Named arguments, corresponding to the validation rules

    # To read more on validations: https://guides.rubyonrails.org/active_record_validations.html
    validates(
        :title, 
        presence: true, 
        uniqueness: true
    )
        
    validates(
        :body, 
        presence: { message: "Must exist" },
        length: { minimum: 10 }
    )

    validates(
        :view_count, 
        numericality: { greater_than_or_equal_to: 0 }
    )

    # Custom Validation
    # Be careful, the method for custom validators is singular and it's almost identical to the same method for regular validations
    validate(:no_monkey)

    # before_validation is a lifecycle callback method that allows us to respond to events during the life of a model instance. e.g. being validated, created, updated, etc.).
    # All lifecycle callback methods take a symbol named after a method, and call that method at the appropriate time.
    before_validation :set_default_view_count

    # Create a scope with a class method
    scope :recent, -> { order(created_at: :desc).limit(10) }
    # Scopes are such a commonly used feature that there is a way to create them quicker. It takes a name and a lambda as a callback.
    # is equivalent to:
    # def self.recent
    #     order(created_at: :desc).limit(10)
    # end

    Question.recent
    
    private
    
    def no_monkey
        # $. is the safe navigation operator. It's used like the . operator to call methods on an object.
        # If the method doesn't exist for the object, 'nil' will be returned instead of getting an error.
        if body&.downcase&.include?("monkey")
            # To make a record invalid, you must add a validation error using the errors `add` method.
            # It's arguments are (in order):
            # - A symbol for the invalid column
            # - An error message as a string
            self.errors.add :body, "must not have monkeys"
        end
    end
    def set_default_view_count
        # If you are writing to an attribute accessor you must prefix with self., which you don't have to do if you're just reading it.
        self.view_count ||= 0
    end
end
