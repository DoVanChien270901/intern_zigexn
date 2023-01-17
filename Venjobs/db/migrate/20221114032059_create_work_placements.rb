class CreateWorkPlacements < ActiveRecord::Migration[7.0]
  def change
    create_table :work_placements do |t|
      t.string :name, index: { unique: true }
      t.timestamps
    end
  end
end
