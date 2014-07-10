class Item < ActiveRecord::Base
  acts_as_taggable_on :keywords

  has_many :item_results, dependent: :destroy
  belongs_to :section

  scope :by_oldest, -> { order("items.created_at ASC") }
  scope :by_identifier, lambda{|identifier| where("identifier = ?", identifier)}

  def self.from_xml(input_xml, section)
    xml = Nokogiri::XML.parse(input_xml)
    identifier = Item.parse_identifier(xml)
    item = Item.find_by(identifier: identifier, section_id: section.id) || section.items.build
    item.identifier = identifier
    item.description = item.question_text = Item.parse_question_text(xml)
    item.title = Item.parse_title(xml)
    item.feedback = Item.parse_feedback(xml)
    item.answers = Item.parse_answers(xml).to_json
    item.item_feedback = Item.parse_item_feedback(xml).to_json
    item.correct_responses = Item.parse_correct_responses(xml).to_json
    item.base_type = Item.parse_base_type(xml)
    item.save!
    item
  end

  def get_feedback(answer_id)
    @feedback ||= nil
    if @feedback.nil?
      @feedback_ids = []
      JSON.parse(self.feedback).each do |fb_id, fb_ids|
        @feedback_ids = fb_ids and break if fb_id == answer_id
      end
      @feedback = get_item_feedback(@feedback_ids.flatten, is_correct?(answer_id))
    end
    @feedback
  end

  def get_item_feedback feedback_ids, is_correct
    @feedback ||= []
    if @feedback.empty?
      item_fb = JSON.parse(self.item_feedback)
      feedback_ids.each do |fb_id|
        @feedback << item_fb["#{fb_id}"] if item_fb.include?(fb_id)
      end
      @feedback << item_fb["general_incorrect_fb"] if !is_correct && item_fb["general_incorrect_fb"]
      @feedback << item_fb["general_fb"] if item_fb["general_fb"]
    end
    @feedback.flatten
  end

  def is_correct?(answer_id)
    JSON.parse(self.correct_responses).include?(answer_id)
  end

  def self.parse_correct_responses(xml)
    correct = []
    xml.css('respcondition').each do |respcondition|
      if respcondition.css('setvar').present? && respcondition.css('setvar').map { |setvar| setvar.content.to_f > 0 }.any?
        correct << respcondition.css('varequal').map { |varequal| varequal.content }
      end
    end
    correct.flatten
  end

  def self.parse_identifier(xml)
    xml.css('item').xpath('@ident').to_s
  end

  def self.parse_title(xml)
    xml.css('item').xpath('@title').to_s
  end

  def self.parse_question_text(xml)
    text = ""
    xml.css('presentation/material/mattext').each do |question_text|
      text = question_text.content
    end
    text
  end

  def self.parse_answers(xml)
    xml.css('response_lid/render_choice/response_label').map do |answer|
      Answer.new( answer.first[1], answer.css('mattext')[0].content )
    end
  end

  def self.parse_feedback(xml)
    feedback_ids = {}
    xml.css('respcondition').each do |respcondition|
      if respcondition.css('varequal')[0].present?
        respcondition.css('varequal').each do |varequal|
          feedback_ids["#{varequal.content}"] = [] if feedback_ids["#{varequal.content}"].nil?
          respcondition.css('displayfeedback').each do |displayfeedback|
            feedback_ids["#{varequal.content}"] << displayfeedback.xpath('@linkrefid').to_s
          end
        end
      end
    end
    feedback_ids.to_json
  end

  def self.parse_item_feedback(xml)
    feedback = {}
    xml.css('itemfeedback').each do |fb|
      ident = fb.xpath('@ident').to_s
      feedback["#{ident}"] = [] if feedback["#{ident}"].nil?
      feedback["#{ident}"] << fb.css('material/mattext').map { |mattext| mattext.content }
      feedback["#{ident}"].flatten!
    end
    feedback
  end

  def self.parse_base_type(xml)
    base_type = ''
    xml.css('itemmetadata/qtimetadata/qtimetadatafield').each do |qtimetadatafield|
      if qtimetadatafield.css('fieldlabel').text == 'question_type'
        base_type = qtimetadatafield.css('fieldentry').text
      end
    end
    base_type
  end

  def self.raw_results( opts={} )
    results = []
    if opts[:scope_url].present?
      results = ItemResult.where("referer LIKE ?", "%#{opts[:scope_url]}%")
    end
    if opts[:identifier].present?
      Item.by_identifier(opts[:identifier]).each do |item|
        item.item_results.each{|item_result| results << item_result }
      end
    end
    if opts[:eid].present?
      ItemResult.where(eid: opts[:eid]).each do |result|
        results << result
      end
    end
    if opts[:keyword].present?
      Assessment.tagged_with(opts[:keyword]).each do |assessment|
        assessment.items.each do |item|
          item.item_results.each{|item_result| results << item_result }
        end
      end
    end

    if opts[:objective].present?
      Assessment.tagged_with(opts[:objective]).each do |assessment|
        assessment.items.each do |item|
          item.item_results.each{|item_result| results << item_result }
        end
      end
    end

    if opts[:external_user_id].present?
      AssessmentResult.where(external_user_id: opts[:external_user_id]).each do |assessment_result|
        assessment_result.item_results.each {|item_result| results << item_result }
      end
    end

    if opts[:src_url].present?
      AssessmentResult.where(src_url: opts[:src_url]).each do |assessment_result|
        assessment_result.item_results.each {|item_result| results << item_result }
      end
    end

    return results

  end

  def self.results_summary( opts={} )

    users = []
    referers = []
    correct = []
    submitted = []
    results = Item.raw_results( opts )

    results.map do |item_result|
      users << item_result.user if !users.include?(item_result.user)
      referers << item_result.referer if !item_result.referer.nil? && !referers.include?(item_result.referer)
      correct << item_result if item_result.item_variable && item_result.item_variable.map { |iv| iv["response_variable"]["correct_response"].include?(iv["response_variable"]["candidate_response"]) }.any?
    end


    results.each do |result|
      if result.session_status == 'final'
        submitted << result
      end
    end

    {
      renders: users.count,
      submitted: submitted,
      users: users,
      referers: referers,
      correct: correct,
      percent_correct: submitted.count > 0 ? correct.count.to_f / submitted.count.to_f : 0
    }
  end

  def raw_results( scope_url=nil )
    return scope_url ? item_results.where("referer LIKE ?", "%#{scope_url}%") : item_results
  end

  def results_summary( scope_url=nil )
    @results_summary ||= begin
      users = []
      referers = []
      correct = []

      results = raw_results( scope_url )

      results.map do |item_result|
        users << item_result.user if !users.include?(item_result.user)
        referers << item_result.referer if !item_result.referer.nil? && !referers.include?(item_result.referer)
        correct << item_result if item_result.item_variable && item_result.item_variable.map { |iv| iv["response_variable"]["correct_response"].include?(iv["response_variable"]["candidate_response"]) }.any?
      end

      submitted = results.by_status_final.load

      {
        renders: users.count,
        submitted: submitted,
        users: users,
        referers: referers,
        correct: correct,
        percent_correct: submitted.count > 0 ? correct.count.to_f / submitted.count.to_f : 0
      }
    end
  end

  def results_summary_csv
    rs = self.results_summary
    CSV.generate do |csv|
      csv << rs.keys
      csv << [rs[:renders], rs[:submitted].count, rs[:users].count, rs[:referers].count, rs[:correct].count, rs[:percent_correct] * 100]
    end
  end

  def results_csv
    results = self.item_results
    CSV.generate do |csv|
      csv << results.column_names
      results.each do |result|
        csv << result.attributes.values_at(*results.column_names)
      end
    end
  end

  def get_answers
    JSON.parse(self.answers).map do |ans_id|
      Answer.new( ans_id["id"], ans_id["text"] )
    end if self.answers
  end

  def set_answers(ans)
    self.answers = ans.to_json
  end


end

class Answer < Struct.new(:id, :text)
end
