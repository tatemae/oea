class Api::ItemsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    item_xml = Nokogiri::XML.parse(request.body.read)
    identifier = item_xml.xpath('//item/@ident').to_s
    unless item = Item.find_by_identifier(identifier)
      item = Item.new
      item.identifier = identifier
      item.xml = item_xml.to_xml
      item.save!
    end
    respond_with(item)
  end
end
