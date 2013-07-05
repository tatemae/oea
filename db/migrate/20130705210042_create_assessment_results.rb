class CreateAssessmentResults < ActiveRecord::Migration
  def change
    create_table :assessment_results do |t|
      t.integer :assessment_id
      t.integer :user_id

      t.timestamps
    end
    add_index :assessment_results, :assessment_id
    add_index :assessment_results, :user_id
  end
end
