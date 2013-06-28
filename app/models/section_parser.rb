class SectionParser
  include HappyMapper

  tag 'section'
  attribute :ident, String
  attribute :title, String

  has_many :items, self, tag: 'item', parser: :identity, raw: true

  def self.identity arg
    arg
  end

  with_nokogiri_config do |config|
    config.strict.nonet
  end
end
