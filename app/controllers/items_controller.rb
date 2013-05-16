class ItemsController < ApplicationController
  def index
  end

  def show
    @item = Item.find(params[:id])
    @item_xml = Nokogiri::XML.parse(@item.xml)
  end
end
