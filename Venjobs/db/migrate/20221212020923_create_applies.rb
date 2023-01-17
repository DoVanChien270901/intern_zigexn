class CreateApplies < ActiveRecord::Migration[7.0]
  def change
    create_table :applies do |t|
      t.string :full_name
      t.string :email
      t.integer :job_id
      t.string :account_user_id
      t.timestamps
    end
  end
end
