class AddExternalUserIdToAssessementResults < ActiveRecord::Migration
  def change
    add_column :assessment_results, :external_user_id, :string
  end
end
