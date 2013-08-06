class AddIndexForSectionIdOnItem < ActiveRecord::Migration
  def up
    remove_index :items, :identifier
    add_index :items, [:identifier, :section_id]
  end

  def down
    remove_index :items, [:identifier, :section_id]
    add_index :items, :identifier
  end
end
