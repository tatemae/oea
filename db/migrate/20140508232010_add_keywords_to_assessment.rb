class AddKeywordsToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :keywords, :string
  end
end
