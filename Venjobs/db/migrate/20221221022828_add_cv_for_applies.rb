class AddCvForApplies < ActiveRecord::Migration[7.0]
  def change
    add_column :applies, :cv, :string
  end
end
