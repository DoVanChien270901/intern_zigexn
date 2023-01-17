class AddRolesAccountUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :account_users, :roles, :integer, default: 0
  end
end
