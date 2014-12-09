class AddItemResultValues < ActiveRecord::Migration
  def change
    add_column :item_results, :correct, :boolean
    add_column :item_results, :score, :float
  end
end
