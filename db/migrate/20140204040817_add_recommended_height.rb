class AddRecommendedHeight < ActiveRecord::Migration
  def change
    add_column :assessments, :recommended_height, :integer
  end
end
