class AddTitleAndDescription < ActiveRecord::Migration
  def change
    add_column :items, :title, :string
    add_column :items, :description, :text
  end
end
