class AssessmentResult < ActiveRecord::Base
  has_one :test_result
  belongs_to :assessment
  has_many :item_results
end
