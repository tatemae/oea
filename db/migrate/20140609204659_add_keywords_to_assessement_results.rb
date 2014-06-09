class AddKeywordsToAssessementResults < ActiveRecord::Migration
  def change
    add_column :assessment_results, :keywords, :string
  end
end
