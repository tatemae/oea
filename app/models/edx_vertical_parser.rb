class EdxVerticalParser
  include HappyMapper

  tag 'vertical'

  attribute :url_name, String

  has_many :problems, EdxProblemParser

  with_nokogiri_config do |config|
    config.strict.nonet
  end
end
