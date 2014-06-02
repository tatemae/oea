class AddEidToAssessmentResults < ActiveRecord::Migration
  def change
    add_column :assessment_results, :eid, :string
  end
end
