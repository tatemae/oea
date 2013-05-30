class Item < ActiveRecord::Base
  has_many :item_results

  def question_text
    text = ""
    parsed_xml.css('presentation/material/mattext').each do |question_text|
      text = item_content(question_text)
    end
    text
  end

  def question_title
    parsed_xml.css('item').xpath('@title').to_s
  end

  def answers
    parsed_xml.css('response_lid/render_choice/response_label').map do |answer|
      Answer.new( answer.first[1], item_content(answer.css('mattext')[0]) )
    end
  end

  def is_correct? answer_id
    parsed_xml.css('varequal')[0].content.to_i == answer_id.to_i
  end

  def correct_response
    parsed_xml.css('varequal')[0].content.to_i
  end

  def base_type
    base_type = ''
    parsed_xml.css('itemmetadata/qtimetadata/qtimetadatafield').each do |qtimetadatafield|
      if qtimetadatafield.css('fieldlabel').text == 'question_type'
        base_type = qtimetadatafield.css('fieldentry').text
      end
    end
    base_type
  end

  def results_summary
    @results_summary ||= begin
      users = []
      referers = []
      correct = []

      item_results.map do |ir|
        users << ir.user if !users.include?(ir.user)
        referers << ir.referer if !ir.referer.nil? && !referers.include?(ir.referer)
        correct << ir if ir.item_variable && ir.item_variable.map { |iv| iv["response_variable"]["correct_response"].to_i == iv["response_variable"]["candidate_response"].to_i }.any?
      end

      submitted = item_results.by_status_final.load

      {
        renders: item_results.count,
        submitted: submitted,
        users: users,
        referers: referers,
        correct: correct,
        percent_correct: submitted.count > 0 ? correct.count.to_f / submitted.count.to_f : 0
      }
    end
  end

  # xml_stream is an xml file or string - anything Nokogiri can parse
  def self.load_qti(xml_stream)
    updates = []
    creates = []
    xml = Nokogiri::XML.parse(xml_stream)
    xml.css('item').each do |item_xml|
      identifier = item_xml.xpath('@ident').to_s
      if item = Item.find_by_identifier(identifier)
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
        updates << creates
      end
    end
    [updates, creates]
  end

  private

    def parsed_xml
      @xml ||= Nokogiri::XML.parse(self.xml)
      @xml
    end

    def item_content(content)
      CGI.unescapeHTML(CGI.unescape(content.to_html)).html_safe
    end

end

class Answer < Struct.new(:id, :text)
end