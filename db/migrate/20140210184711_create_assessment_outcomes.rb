class CreateAssessmentOutcomes < ActiveRecord::Migration
  def change
    create_table :assessment_outcomes do |t|
      t.integer :assessment_id
      t.integer :outcome_id

      t.timestamps
    end
  end
end
