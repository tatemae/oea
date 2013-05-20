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
