class Api::ItemsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    page = (params[:page] || 1).to_i
    per_page = 10
    items = Item.where("items.xml LIKE ?", "%#{params[:q]}%").paginate(:page => page, :per_page => per_page)
    respond_with(items, :only => [:id, :title, :description])
  end

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

  # TODO this isn't a RESTful method. We need to reconsider how this is used/implemented
  def create_questions
    xml = Nokogiri::XML.parse(request.body.read)
    xml.css('item').each do |item_xml|
      identifier = item_xml.xpath('@ident').to_s
      if item = Item.find_by_identifier(identifier)
        item.update_attributes(:xml => item_xml.to_xml)
        puts "Updated item #{identifier}"
      else
        item = Item.new
        item.identifier = item_xml.xpath('@ident').to_s
        item.xml = item_xml.to_xml
        item.save!
        puts "Created item #{identifier}"
      end
    end
    render nothing: true
  end
end
