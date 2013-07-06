class Api::ItemsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :xml, :json

  def index
    page = (params[:page] || 1).to_i
    per_page = 10
    items = Item.where("items.xml LIKE ?", "%#{params[:q]}%").paginate(:page => page, :per_page => per_page)
    respond_with(items, :only => [:id, :title, :description])
  end

  def create
    item_xml = Nokogiri::XML.parse(request.body.read)
    identifier = item_xml.xpath('//item/@ident').to_s
    unless item = Item.find_by(identifier: identifier)
      item = Item.new
      item.identifier = identifier
      item.xml = item_xml.to_xml
      item.save!
    end
    respond_with(item)
  end
end
