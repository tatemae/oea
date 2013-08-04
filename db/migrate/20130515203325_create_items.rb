class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :external_id, unique: true
      t.text :xml, limit: 2**20

      t.timestamps
    end
    add_index :items, :external_id
  end
end
