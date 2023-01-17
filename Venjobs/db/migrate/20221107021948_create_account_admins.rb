class CreateAccountAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :account_admins, primary_key: :admin_name, id: false do |t|
      t.string :admin_name, primary_key: true
      t.string :password
      t.string :fullname
      t.timestamps
    end
  end
end
