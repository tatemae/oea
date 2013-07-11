class RemoveXmlFromModels < ActiveRecord::Migration
  def self.up
    remove_column :assessments, :xml
    remove_column :sections, :xml
  end

  def self.down
    add_column :sections, :xml, :string, :limit => 2**20
    add_column :assessments, :xml, :string, :limit => 2**20
  end
end
