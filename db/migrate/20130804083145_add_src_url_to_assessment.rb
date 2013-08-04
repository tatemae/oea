class AddSrcUrlToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :src_url, :string
    add_index :assessments, :src_url
  end
end
