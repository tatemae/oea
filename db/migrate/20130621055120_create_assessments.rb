class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.string :xml, limit: 2**20, unique: true
      t.string :identifier

      t.timestamps
    end
    add_index :assessments, :identifier
  end
end
