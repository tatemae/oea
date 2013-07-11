class RemoveQuestionTitleFromItem < ActiveRecord::Migration
  def self.up
    remove_column :items, :question_title
  end

  def self.down
    add_column :items, :question_title, :string
  end
end
