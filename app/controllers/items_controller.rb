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
      if !@user = User.find_by_name(request.session.id)
        @user = User.create_anonymous
        @user.name = request.session.id
        @user.save!
      end
      @user.item_results.create!(:identifier => params[:identifier], :item_id => @item.id, :datestamp => Time.now, :referer => request.referer, :ip_address => request.ip)
      if @item.is_correct?(@selected_answer_id)
        flash[:persistent_alert] = 'Correct'
      else
        flash[:persistent_alert] = 'Incorrect'
      end
    end
  rescue
    redirect_to items_path, :notice => 'Item not found...'
  end
end
