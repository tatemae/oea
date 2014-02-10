class AddOutcomeIndexes < ActiveRecord::Migration
  def change
    add_index :assessment_outcomes, :assessment_id
    add_index :assessment_outcomes, :outcome_id
    add_index :assessment_outcomes, [:assessment_id, :outcome_id]
  end
end
