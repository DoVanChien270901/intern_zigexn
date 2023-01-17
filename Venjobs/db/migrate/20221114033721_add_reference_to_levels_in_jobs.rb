class AddReferenceToLevelsInJobs < ActiveRecord::Migration[7.0]
  def change
    add_reference :jobs, :level, index: true
  end
end
