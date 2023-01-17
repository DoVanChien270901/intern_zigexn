class AddReferenceToCompanyWorkPlacementsInJobs < ActiveRecord::Migration[7.0]
  def change
    add_reference :jobs, :work_placement, index: true
  end
end
