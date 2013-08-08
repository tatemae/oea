class AddPublishedAtToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :published_at, :datetime
  end
end
