class AddFieldsToItem < ActiveRecord::Migration
  def change
    add_column :items, :question_text, :string
    add_column :items, :question_title, :string
    add_column :items, :answers, :string
    add_column :items, :feedback, :string
    add_column :items, :item_feedback, :text, limit: 2**15
    add_column :items, :correct_responses, :string
    add_column :items, :base_type, :string
  end
end
