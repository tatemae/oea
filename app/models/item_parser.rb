class ItemParser
  include HappyMapper

  tag 'item'
  attribute :ident, String

  with_nokogiri_config do |config|
    config.strict.nonet
  end
end
