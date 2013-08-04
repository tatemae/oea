class ChangeItemFieldSizes < ActiveRecord::Migration
  def self.up
    change_column :items, :description, :text, :limit => 2**15
    change_column :items, :question_text, :text, :limit => 2**15
    change_column :items, :answers, :string, :text => 2**15
    change_column :items, :feedback, :string, :text => 2**15
    change_column :items, :correct_responses, :text, :limit => 2**15
  end

  def self.down
    change_column :items, :description, :string
    change_column :items, :question_text, :string
    change_column :items, :answers, :string
    change_column :items, :feedback, :string
    change_column :items, :correct_responses, :string
  end
end
