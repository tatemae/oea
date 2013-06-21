class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.string :xml
      t.string :identifier

      t.timestamps
    end
  end
end
