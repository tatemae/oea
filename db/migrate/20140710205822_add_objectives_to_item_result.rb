class AddObjectivesToItemResult < ActiveRecord::Migration
  def change
    add_column :item_results, :objectives, :string
  end
end
