class CreateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :histories do |t|
      t.string :account_user_id
      t.integer :job_id
      t.index %i[account_user_id job_id], unique: true
      t.timestamps
    end
  end
end
