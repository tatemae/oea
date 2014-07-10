class AddObjectivesToAssessmentResult < ActiveRecord::Migration
  def change
    add_column :assessment_results, :objectives, :string
  end
end
