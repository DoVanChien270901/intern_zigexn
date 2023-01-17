class CreateCities < ActiveRecord::Migration[7.0]
  def change
    create_table :cities do |t|
      t.integer :code
      t.string :name, index: { unique: true }
      t.timestamps
    end
  end
end
