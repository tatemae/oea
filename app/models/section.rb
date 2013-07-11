class Section < ActiveRecord::Base

  has_many :items, dependent: :destroy
  belongs_to :assessment

  after_initialize :munge_xml

  def munge_xml
    @parsed_xml ||= SectionParser.parse(self.xml)
  end

  before_create :create_subitems

  def create_subitems
    self.identifier = @parsed_xml.ident
    self.items << @parsed_xml.items.collect do |item|

      xml = Item.parsed_xml(item)

      args = {
        identifier: Item.identifier(xml),
        title: Item.title(xml),
        question_text: Item.question_text(xml),
        answers: Item.answers(xml).to_json,
        feedback: Item.feedback(xml),
        item_feedback: Item.item_feedback(xml),
        correct_responses: Item.correct_responses(xml),
        base_type: Item.base_type(xml)
      }
      Item.new(args)

    end
  end

  delegate :title, to: :@parsed_xml
end
