class AddAssessmentResultIdToItemResult < ActiveRecord::Migration
  def change
    add_column :item_results, :assessment_result_id, :integer
    add_index :item_results, :assessment_result_id
  end
end
