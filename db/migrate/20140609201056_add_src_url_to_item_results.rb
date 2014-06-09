class AddSrcUrlToItemResults < ActiveRecord::Migration
  def change
    add_column :item_results, :src_url, :string
  end
end
