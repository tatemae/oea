class AddUserIdToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :user_id, :integer
  end
end
