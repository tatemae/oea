class AddAssessmentIdToAssessmentXml < ActiveRecord::Migration
  def change
    add_column :assessment_xmls, :assessment_id, :integer
  end
end
