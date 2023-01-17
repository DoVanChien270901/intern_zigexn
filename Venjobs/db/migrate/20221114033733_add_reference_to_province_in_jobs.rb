class AddReferenceToProvinceInJobs < ActiveRecord::Migration[7.0]
  def change
    add_reference :jobs, :province, index: true
  end
end
