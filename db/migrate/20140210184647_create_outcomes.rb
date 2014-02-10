class CreateOutcomes < ActiveRecord::Migration
  def change
    create_table :outcomes do |t|
      t.string :name
      t.string :mc3_bank_id
      t.string :mc3_objective_id

      t.timestamps
    end
  end
end
