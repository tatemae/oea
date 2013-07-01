class AddTitleAndDescriptionToAssessments < ActiveRecord::Migration
  def change
    add_column :assessments, :title, :string
    add_column :assessments, :description, :text
  end
end
