class AddcolumnAccountUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :account_users, :encrypted_password, :string
  end
end
