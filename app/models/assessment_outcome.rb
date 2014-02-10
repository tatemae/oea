class AssessmentOutcome < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :outcome
end
