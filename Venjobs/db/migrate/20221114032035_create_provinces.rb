class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces do |t|
      t.string :name, index: { unique: true }
      t.string :country
      t.timestamps
    end
  end
end
