class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
    @item_xml = Nokogiri::XML.parse(@item.xml)
  end
end
