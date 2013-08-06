class AddUserIdIndexToSrcUrlOnAssessments < ActiveRecord::Migration
  def up
    remove_index :assessments, :src_url
    add_index :assessments, [:src_url, :user_id]
  end

  def down
    remove_index :assessments, [:src_url, :user_id]
    add_index :assessments, :src_url
  end
end
