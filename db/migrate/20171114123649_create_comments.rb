class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :body, null: :false

      t.references :commentable, polymorphic: true, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
