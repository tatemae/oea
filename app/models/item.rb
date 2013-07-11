class Item < ActiveRecord::Base
  has_many :item_results, dependent: :destroy
  belongs_to :section

  # after_initialize :munge_xml

  scope :by_oldest, -> { order("items.created_at ASC") }

  # def munge_xml
  #   if self.xml
  #     @parsed_xml ||= ItemParser.parse(self.xml)
  #     self.identifier = @parsed_xml.ident
  #   end
  # end

  def self.identifier xml
    parsed_xml = ItemParser.parse(xml)
    parsed_xml.ident
  end

  def self.question_text xml
    text = ""
    xml.css('presentation/material/mattext').each do |question_text|
      text = self.item_content(question_text)
    end
    text
  end

  def self.title xml
    xml.css('item').xpath('@title').to_s
  end

  def self.answers xml
    xml.css('response_lid/render_choice/response_label').map do |answer|
      Answer.new( answer.first[1], self.item_content(answer.css('mattext')[0]) )
    end
  end

  # def feedback answer_id
  #   @feedback ||= nil
  #   if @feedback.nil?
  #     @feedback_ids = []
  #     parsed_xml.css('respcondition').each do |respcondition|
  #       if respcondition.css('varequal')[0].present? && respcondition.css('varequal').map { |varequal| varequal.content }.include?(answer_id)
  #         respcondition.css('displayfeedback').each do |displayfeedback|
  #           @feedback_ids << displayfeedback.xpath('@linkrefid').to_s
  #         end
  #       end
  #     end
  #     @feedback = item_feedback(@feedback_ids.flatten, is_correct?(answer_id))
  #   end
  #   @feedback
  # end

  # def item_feedback feedback_ids, is_correct
  #   @feedback ||= []
  #   if @feedback.empty?
  #     parsed_xml.css('itemfeedback').each do |feedback|
  #       if feedback_ids.include?(feedback.xpath('@ident').to_s)
  #         @feedback << feedback.css('material/mattext').map { |mattext| mattext.content }
  #       end
  #       if feedback.xpath('@ident').to_s == 'general_fb'
  #         @feedback << feedback.css('material/mattext').map { |mattext| mattext.content }
  #       end
  #       if !is_correct && feedback.xpath('@ident').to_s == 'general_incorrect_fb'
  #         @feedback << feedback.css('material/mattext').map { |mattext| mattext.content }
  #       end
  #     end
  #   end
  #   @feedback.flatten
  # end

  def self.feedback xml
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

  def self.item_feedback xml
    feedback = {}
    xml.css('itemfeedback').each do |fb|
      ident = fb.xpath('@ident').to_s
      feedback["#{ident}"] = [] if feedback["#{ident}"].nil?
      feedback["#{ident}"] << fb.css('material/mattext').map { |mattext| mattext.content }
      feedback["#{ident}"].flatten!
    end
    feedback.to_json
  end

  def is_correct? answer_id
    correct_responses.include?(answer_id)
  end

  def self.correct_responses xml
    correct = []
    xml.css('respcondition').each do |respcondition|
      if respcondition.css('setvar').present? && respcondition.css('setvar').map { |setvar| setvar.content.to_f > 0 }.any?
        correct << respcondition.css('varequal').map { |varequal| varequal.content }
      end
    end
    correct.flatten.to_json
  end

  def self.base_type xml
    base_type = ''
    xml.css('itemmetadata/qtimetadata/qtimetadatafield').each do |qtimetadatafield|
      if qtimetadatafield.css('fieldlabel').text == 'question_type'
        base_type = qtimetadatafield.css('fieldentry').text
      end
    end
    base_type
  end

  def raw_results( scope_url = nil )
    results = scope_url ? item_results.where("referer LIKE ?", "%#{scope_url}%") : item_results
  end

  def results_summary( scope_url = nil )
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

  # xml_stream is an xml file or string - anything Nokogiri can parse
  def self.load_qti(xml_stream)
    updates = []
    creates = []
    xml = Nokogiri::XML.parse(xml_stream)
    xml.css('item').each do |item_xml|
      identifier = item_xml.xpath('@ident').to_s
      if item = Item.find_by(identifier: identifier)
        item.xml = item_xml.to_xml
        item.title = item.question_title
        item.description = item.question_text
        item.save!
        updates << item
      else
        item = Item.new
        item.identifier = item_xml.xpath('@ident').to_s
        item.xml = item_xml.to_xml
        item.title = item.question_title
        item.description = item.question_text
        item.save!
        updates << item
      end
    end
    [updates, creates]
  end

  def self.parsed_xml xml
    xml = Nokogiri::XML.parse(xml)
    xml
  end

  private

    def self.item_content(content)
      CGI.unescapeHTML(CGI.unescape(content.to_html)).html_safe
    end

end

class Answer < Struct.new(:id, :text)
end
