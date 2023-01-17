class AddUniqueApplies < ActiveRecord::Migration[7.0]
  def change
    add_index :applies, %i[job_id account_user_id], unique: true
  end
end
