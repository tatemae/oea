class AddExternalUserIdToItemResults < ActiveRecord::Migration
  def change
    add_column :item_results, :external_user_id, :string
  end
end
