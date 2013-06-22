class AddSectionIdToItemss < ActiveRecord::Migration
  def change
    add_column :items, :section_id, :integer
  end
end
