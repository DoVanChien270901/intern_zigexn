class AddCountJobForCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :count_job, :integer
  end
end
