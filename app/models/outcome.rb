class Outcome < ActiveRecord::Base
  has_many :assessment_outcomes
  has_many :assessments, through: :assessment_outcomes
end
