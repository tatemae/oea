class AssessmentResult < ActiveRecord::Base
  has_one :test_result, dependent: :destroy
  belongs_to :assessment
  has_many :item_results, dependent: :destroy
end
