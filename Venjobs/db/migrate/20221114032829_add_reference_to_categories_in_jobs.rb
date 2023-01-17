class AddReferenceToCategoriesInJobs < ActiveRecord::Migration[7.0]
  def change
    add_reference :jobs, :category, index: true
  end
end
