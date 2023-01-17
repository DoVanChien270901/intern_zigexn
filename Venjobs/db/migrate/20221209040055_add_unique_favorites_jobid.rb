class AddUniqueFavoritesJobid < ActiveRecord::Migration[7.0]
  def change
    add_index :favorites, %i[job_id account_user_id], unique: true
  end
end
