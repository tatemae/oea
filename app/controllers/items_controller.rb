class ItemsController < ApplicationController
  respond_to :json, :html

  def index
    @section = Section.find(params[:section_id])
    @items = @section.items
    @rendered_time = Time.now
    @referer = request.env['HTTP_REFERER']
  end

  def show
    @item = Item.find(params[:id])
    create_item_result(@item)
    respond_to do |format|
      format.html { render :layout => 'bare' }
    end
  end

  def check_answer
    @item = Item.find(params[:item][:id])
    @rendered_time = Time.now
    if @item
      @selected_answer_id = params["#{@item.id}"]
      if !@user = User.find_by(name: request.session.id)
        @user = User.create_anonymous
        @user.name = request.session.id
        @user.save!
      end
      create_result = false
      if !params[:item][:item_result_id].blank? && @item_result = ItemResult.find(params[:item][:item_result_id])
        if @item_result.user.id == @user.id
          @item_result.datestamp = Time.now
          @item_result.item_variable = [{
            "response_variable"=>{
              "id"=>@item.id,
              "correct_response"=>@item.correct_responses,
              "base_type"=>@item.base_type,
              "candidate_response"=>@selected_answer_id
            }
          }]
          @item_result.referer = params[:item][:referer]
          @item_result.session_status = 'final'
          @item_result.save!
        else
          create_result = true
        end
      else
        create_result = true
      end
      if create_result
        @item_result = @user.item_results.create!(
          :identifier => @item.identifier,
          :item_id => @item.id,
          :rendered_datestamp => params[:item][:rendered_time],
          :datestamp => Time.now,
          :referer => params[:item][:referer],
          :ip_address => request.ip,
          :session_status => 'final',
          :item_variable => [{
            "response_variable"=>{
              "id"=>@item.id,
              "correct_response"=>@item.correct_responses,
              "base_type"=>@item.base_type,
              "candidate_response"=>@selected_answer_id
            }
          }])
      end
      @result = @item.is_correct?(@selected_answer_id)
    end
    if @result
      words = 'correct'
      percent_correct = 100
    else
      words = 'incorrect'
      percent_correct = 0
    end
    result = {
      :id => @item.id,
      :correct => @result,
      :percent_correct => percent_correct,
      :source => 'http://www.openassessments.com',
      :html => %Q{<div class="tooltip-inner #{words}""><span class='result_words'>#{words.capitalize}!</span></div>}
    }
    respond_to do |format|
      format.json { render :json => result }
    end
  rescue => e
    respond_to do |format|
      format.json { render :json => e.to_s }
      format.html { redirect_to :back, :notice => e.to_s }
    end
  end
end
