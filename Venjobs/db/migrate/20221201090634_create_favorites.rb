class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.integer :job_id
      t.string :account_user_id, unique: true
      t.timestamps
    end
  end
end
