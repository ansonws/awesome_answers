class QuestionSerializer < ActiveModel::Serializer
  # ActiveModel::Serializer Docs:
  # https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/README.md
  
  # Use the 'attributes' method to specify which methods of a model to include in its serialization output.
  attributes(
    :id, 
    :title, 
    :body, 
    :like_count,
    :view_count, 
    :created_at, 
    :updated_at
  ) 

  # To include associate models, use the same named methods used for creating associations. You can rename the association with "key" which will only in the serialized output
  belongs_to(:user, key: :author)
  
  has_many :answers

  # To customize serialization for associated models, you can define a serializer within the current serializer.
  # This would replace any global serializer.
  class AnswerSerializer < ActiveModel::Serializer
    attributes :id, :body, :created_at, :updated_at

    # This will not work by default as Rails does not include nested associations when serializing automatically
    belongs_to(:user, key: :author)
  end

  def like_count
    # 'object' is assigned the instance of the model being serializer. 
    # Use it where you would use `self` in instance methods of the model's class.
    object.likes.count
  end
end
