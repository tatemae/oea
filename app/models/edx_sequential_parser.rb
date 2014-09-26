class EdxSequentialParser
  include HappyMapper

  tag 'sequential'

  attribute :display_name, String

  has_many :verticals, EdxVerticalParser

  with_nokogiri_config do |config|
    config.strict.nonet
  end
end
