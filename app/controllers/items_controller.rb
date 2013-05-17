class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def check_answer
    @item = Item.find(params[:name])
    if @item
      #TODO: record response
      if @item.is_correct? params[:value]
        flash[:notice] = 'Correct'
      else
        flash[:notice] = 'Incorrect'
      end
    end
  end
end
