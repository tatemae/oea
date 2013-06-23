class AssessmentParser
  include HappyMapper

  tag 'assessment'

  attribute :ident, String
  attribute :title, String
  has_many :sections, self, tag: 'section', parser: :identity, raw: true

  def self.identity arg
    arg
  end

  with_nokogiri_config do |config|
    config.strict.nonet
  end
end
