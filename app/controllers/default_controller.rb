class DefaultController < ApplicationController
  def index
    items = Item.all
    @items = {}
    items.each do |item|
      @items[item.id] = Nokogiri::XML.parse(item.xml)
    end
  end
end
