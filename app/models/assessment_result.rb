class AssessmentResult < ActiveRecord::Base
  has_one :test_result
  has_many :item_results
end
