class AddKeywordsToItems < ActiveRecord::Migration
  def change
  	add_column :items, :keywords, :string
  end
end
