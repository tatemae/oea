class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :xml, limit: 2**20, unique: true
      t.string :identifier
      t.integer :assessment_id

      t.timestamps
    end
    add_index :sections, :identifier
  end
end
