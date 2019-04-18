class AddUserReferencesToJobPosts < ActiveRecord::Migration[5.2]
  # This file was generated with the command
  # > rails g migration
  # rails g migration add_user_references_to_job_posts user:references
  def change
    add_reference :job_posts, :user, foreign_key: true
  end
end
