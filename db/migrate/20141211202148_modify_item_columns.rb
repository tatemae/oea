class ModifyItemColumns < ActiveRecord::Migration
  def change
    change_column :items, :answers, :text
    change_column :items, :feedback, :text
    change_column :items, :title, :string, limit: 512
    change_column :items, :keywords, :string, limit: 512
  end
end
