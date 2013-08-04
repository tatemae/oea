class CreateAssessmentXmls < ActiveRecord::Migration
  def change
    create_table :assessment_xmls do |t|
      t.text :xml, limit: 2**20

      t.timestamps
    end
  end
end
