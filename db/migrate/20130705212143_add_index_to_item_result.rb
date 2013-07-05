class AddIndexToItemResult < ActiveRecord::Migration
  def change
    add_index :item_results, :item_id
    add_index :item_results, :user_id
  end
end
