class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :score , default: 0, null: false
      t.references :votable, polymorphic: true, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end

    add_index :votes, [:user_id, :votable_id, :votable_type], unique:true
  end
end
