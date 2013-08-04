class AddFieldsToAssessmentResults < ActiveRecord::Migration
  def change
    add_column :assessment_results, :rendered_datestamp, :datetime
    add_column :assessment_results, :session_status, :string
    add_column :assessment_results, :referer, :string
    add_column :assessment_results, :ip_address, :string
  end
end
