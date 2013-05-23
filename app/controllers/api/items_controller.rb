class Api::ItemsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    item_xml = Nokogiri::XML.parse(request.body.read)
    item = Item.new
    item.identifier = item_xml.xpath('//item/@ident').to_s
    item.xml = item_xml.to_xml
    item.save!
    respond_with(item)
  end
end
