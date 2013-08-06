class AddIndexToUserIdOnAssessment < ActiveRecord::Migration
  def up
    remove_index :assessments, :identifier
    add_index :assessments, [:identifier, :user_id]
  end

  def down
    remove_index :assessments, [:identifier, :user_id]
    add_index :assessments, :identifier
  end

end
