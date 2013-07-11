class RemoveXmlFromItem < ActiveRecord::Migration
  def self.up
    remove_column :items, :xml
  end

  def self.down
    add_column :items, :xml, :string, :limit => 2**20
  end
end
