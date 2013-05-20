class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def check_answer
    @item = Item.find(params[:item][:id])
    if @item
      @selected_answer_id = params["#{@item.id}"]
      @item_result = ItemResult.create!(:identifier => params[:identifier], :item_id => @item.id, :datestamp => Time.now, :referer => request.referer, :ip_address => request.ip)
      if @item.is_correct?(@selected_answer_id)
        flash[:notice] = 'Correct'
      else
        flash[:notice] = 'Incorrect'
      end
    end
  rescue
    redirect_to items_path, :notice => 'Item not found...'
  end
end
