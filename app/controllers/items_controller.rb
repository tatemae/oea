class ItemsController < ApplicationController
  def index
    @items = Item.all
    @rendered_time = Time.now
  end

  def show
    @item = Item.find(params[:id])
    @rendered_time = Time.now
  end

  def check_answer
    @item = Item.find(params[:item][:id])
    @rendered_time = Time.now
    if @item
      @selected_answer_id = params["#{@item.id}"]
      if !@user = User.find_by_name(request.session.id)
        @user = User.create_anonymous
        @user.name = request.session.id
        @user.save!
      end
      @item_result = @user.item_results.create!(
        :identifier => @item.identifier,
        :item_id => @item.id,
        :rendered_datestamp => params[:item][:rendered_time],
        :datestamp => Time.now,
        :referer => request.referer,
        :ip_address => request.ip,
        :session_status => "final",
        :item_variable => [{"response_variable"=>{"id"=>@item.id,"correct_response"=>@item.correct_response,"base_type"=>@item.base_type,"candidate_response"=>@selected_answer_id}}])
      @result = @item.is_correct?(@selected_answer_id)
    end
  rescue => e
    redirect_to items_path, :notice => e.to_s
  end
end
