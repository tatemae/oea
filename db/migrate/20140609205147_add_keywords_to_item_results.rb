class AddKeywordsToItemResults < ActiveRecord::Migration
  def change
    add_column :item_results, :keywords, :string
  end
end
