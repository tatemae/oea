class EdxProblemParser
  include HappyMapper

  tag 'problem'

  attribute :url_name, String

  with_nokogiri_config do |config|
    config.strict.nonet
  end
end
