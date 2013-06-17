class RawResultsController < ApplicationController

  def index
    @item = Item.find(params[:item_id])
  end

  def show
  end
end
