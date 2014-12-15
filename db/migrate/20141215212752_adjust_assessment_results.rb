class AdjustAssessmentResults < ActiveRecord::Migration
  def change
    change_column :assessment_results, :referer, :string, limit: 2048
    change_column :assessment_results, :src_url, :string, limit: 2048
    change_column :assessment_results, :identifier, :string, limit: 512
    change_column :assessment_results, :eid, :string, limit: 512
    change_column :assessment_results, :keywords, :string, limit: 512
    change_column :assessment_results, :objectives, :string, limit: 1024
  end
end
