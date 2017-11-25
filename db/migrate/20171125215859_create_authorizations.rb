class CreateAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizations do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :authorizations, [:provider, :uid]
  end
end
