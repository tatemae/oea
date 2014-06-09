class AddIdentifierToAssessementResults < ActiveRecord::Migration
  def change
    add_column :assessment_results, :identifier, :string
  end
end
