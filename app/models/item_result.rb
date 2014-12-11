class ItemResult < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  belongs_to :assessment_result

  acts_as_taggable_on :keywords
  acts_as_taggable_on :objectives

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

  def self.raw_results( opts={} )
    results = []
    if opts[:scope_url].present?
      results = ItemResult.where("referer LIKE ?", "%#{opts[:scope_url]}%")
    end

    if opts[:identifier].present?
      results.concat ItemResult.where(identifier: opts[:identifier])
    end

    if opts[:eid].present?
      results.concat ItemResult.where(eid: opts[:eid])
    end

    if opts[:keyword].present?
      results.concat ItemResult.tagged_with(opts[:keyword])
    end

    if opts[:objective].present?
      results.concat ItemResult.tagged_with(opts[:objective])
    end

    if opts[:external_user_id].present?
      results.concat ItemResult.where(external_user_id: opts[:external_user_id])
    end

    if opts[:src_url].present?
      results.concat ItemResult.where(src_url: opts[:src_url])
    end

    results

  end

  def self.results_summary(results)

    users = []
    referers = []
    correct = []
    submitted = []
    time_elapsed = []
    confidence_level = []
    identifiers = {}

    results.each do |item_result|
      identifiers[item_result.identifier] ||= []
      identifiers[item_result.identifier] << item_result
      users << item_result.user if !users.include?(item_result.user)
      referers << item_result.referer if !item_result.referer.nil? && !referers.include?(item_result.referer)
      correct << item_result if item_result.correct
      time_elapsed << item_result.time_elapsed
      confidence_level << item_result.confidence_level
    end

    results.each do |result|
      if result.session_status == 'final'
        submitted << result
      end
    end

    item_summaries = []
    identifiers.each do |identifier, item_results|
      
      final_submissions = item_results.find_all{|ir| ir.session_status == 'final'}
      number_submitted = final_submissions.count
      total_correct = final_submissions.find_all{|ir| ir.correct}.count

      item_summaries << {
        identifier: identifier,
        number_renders: item_results.length,
        number_submitted: number_submitted,
        percent_correct: (total_correct.to_f/number_submitted.to_f) * 100,
        number_referers: item_results.map(&:referer).uniq.count,
        number_of_users: item_results.map(&:user_id).uniq.count
      }
    end

    {
      identifiers: identifiers,
      item_summaries: item_summaries,
      renders: users.count,
      submitted: submitted,
      users: users,
      referers: referers,
      correct: correct,
      percent_correct: submitted.count > 0 ? correct.count.to_f / submitted.count.to_f : 0,
      time_elapsed: average_of(time_elapsed) || 0,
      confidence_level: average_of(confidence_level) || 'none'
    }
  end

  def self.average_of(arr)
    return 0 if arr.blank?
    arr.inject(0.0) { |sum, el| sum + (el || 0) } / arr.size
  end

end
