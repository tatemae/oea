class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.text :xml, limit: 2**20
      t.string :identifier, unique: true

      t.timestamps
    end
    add_index :assessments, :identifier
  end
end
