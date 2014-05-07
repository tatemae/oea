class AddTimeElapsedToItemResults < ActiveRecord::Migration
  def change
    add_column :item_results, :time_elapsed, :integer
  end
end
