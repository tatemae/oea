class ChangeExternalIdToIdentifierForItem < ActiveRecord::Migration
  def change
    rename_column :items, :external_id, :identifier
  end
end
