class CreateAccountUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :account_users, primary_key: :user_name, id: false do |t|
      t.string :user_name, primary_key: true
      t.string :full_name
      t.string :email
      t.timestamps
    end
  end
end
