class AddSrcUrlToAssessementResults < ActiveRecord::Migration
  def change
    add_column :assessment_results, :src_url, :string
  end
end
