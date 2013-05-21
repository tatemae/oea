class ChangeItemVariableInItemResult < ActiveRecord::Migration
  def self.up
    change_column :item_results, :item_variable, :string, :limit => 2**20
  end

  def self.down
    change_column :item_results, :item_variable, :string
  end
end
