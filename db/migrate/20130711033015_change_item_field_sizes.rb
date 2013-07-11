class ChangeItemFieldSizes < ActiveRecord::Migration
  def self.up
    change_column :items, :description, :string, :limit => 2**15
    change_column :items, :question_text, :string, :limit => 2**15
    change_column :items, :answers, :string, :limit => 2**15
    change_column :items, :feedback, :string, :limit => 2**15
    change_column :items, :correct_responses, :string, :limit => 2**15
  end

  def self.down
    change_column :items, :description, :string
    change_column :items, :question_text, :string
    change_column :items, :answers, :string
    change_column :items, :feedback, :string
    change_column :items, :correct_responses, :string
  end
end
