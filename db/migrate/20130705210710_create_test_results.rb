class CreateTestResults < ActiveRecord::Migration
  def change
    create_table :test_results do |t|
      t.integer :assessment_result_id
      t.integer :identifier
      t.datetime :datestamp
      t.text :item_variable, :limit => 2**20

      t.timestamps
    end
    add_index :test_results, :assessment_result_id
    add_index :test_results, :identifier
  end
end
