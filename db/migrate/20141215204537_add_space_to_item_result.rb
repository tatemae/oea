class AddSpaceToItemResult < ActiveRecord::Migration
  def change
    change_column :item_results, :identifier, :string, limit: 512
    change_column :item_results, :candidate_comment, :string, limit: 512
    change_column :item_results, :eid, :string, limit: 512
    change_column :item_results, :src_url, :string, limit: 2048
    change_column :item_results, :keywords, :string, limit: 512
    change_column :item_results, :objectives, :string, limit: 1024
    change_column :item_results, :referer, :string, limit: 2048
  end
end
