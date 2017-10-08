class AddUserIdToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :questions, :user, index: true
  end
end
