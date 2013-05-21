class ItemResult < ActiveRecord::Base
  belongs_to :item
  belongs_to :user

  before_save :validate_session_status

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

end
