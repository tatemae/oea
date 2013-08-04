class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.text :xml, limit: 2**20
      t.string :identifier, unique: true
      t.integer :assessment_id

      t.timestamps
    end
    add_index :sections, :identifier
  end
end
