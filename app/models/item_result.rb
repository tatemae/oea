class ItemResult < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :assessment_result

  acts_as_taggable_on :keywords

  before_save :validate_session_status

  scope :by_status_final, -> { where(session_status: 'final') }

  STATUS_INITIAL = 'initial'
  STATUS_PENDING_SUBMISSION = 'pendingSubmission'
  STATUS_PENDING_RESPONSE_PROCESSING  = 'pendingResponseProcessing'
  STATUS_FINAL = 'final'

  STATUS_VALUES = [STATUS_INITIAL, STATUS_PENDING_SUBMISSION, STATUS_PENDING_RESPONSE_PROCESSING, STATUS_FINAL]

  def validate_session_status
    if !STATUS_VALUES.include?(self.session_status)
      raise "Not a valid session status."
    end
  end

  def item_variable=(hash)
    write_attribute(:item_variable, hash.to_json)
  end

  def item_variable
    JSON.parse(read_attribute(:item_variable)) rescue nil
  end

end
