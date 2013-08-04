class ChangeItemVariableInItemResult < ActiveRecord::Migration
  def self.up
    change_column :item_results, :item_variable, :text, :limit => 2**20
  end

  def self.down
    change_column :item_results, :item_variable, :text
  end
end
