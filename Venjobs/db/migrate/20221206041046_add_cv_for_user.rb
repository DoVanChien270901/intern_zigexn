class AddCvForUser < ActiveRecord::Migration[7.0]
  def change
    add_column :account_users, :cv, :string
  end
end
