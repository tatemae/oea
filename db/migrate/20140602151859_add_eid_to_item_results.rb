class AddEidToItemResults < ActiveRecord::Migration
  def change
    add_column :item_results, :eid, :string
  end
end
