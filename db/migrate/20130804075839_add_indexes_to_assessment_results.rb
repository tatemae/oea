class AddIndexesToAssessmentResults < ActiveRecord::Migration
  def change
    add_index :assessment_results, :referer
  end
end
