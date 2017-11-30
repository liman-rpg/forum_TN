class AddConfirmationToAuthorizations < ActiveRecord::Migration[5.1]
  def change
    add_column :authorizations, :status, :boolean,  default: false, null: false
    add_column :authorizations, :email_confirmed, :boolean, default: false, null: false
    add_column :authorizations, :confirm_token, :string, default: nil
  end
end
