class AddConfidenceLevelToItemResult < ActiveRecord::Migration
  def change
    add_column :item_results, :confidence_level, :integer
  end
end
