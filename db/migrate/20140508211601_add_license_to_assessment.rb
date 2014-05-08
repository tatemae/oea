class AddLicenseToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :license, :string
  end
end
