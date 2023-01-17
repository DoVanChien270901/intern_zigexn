class ChangeColumnAccountUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :account_users, :email, :password
    rename_column :account_users, :user_name, :email
  end
end
