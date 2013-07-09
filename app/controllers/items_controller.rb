class ItemsController < ApplicationController
  respond_to :json, :html

  skip_before_filter :verify_authenticity_token, :only => [:check_answer]

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

    @user_response = params["#{@item.id}"]
    if !@user = User.find_by(name: request.session.id)
      @user = User.create_anonymous
      @user.name = request.session.id
      @user.save!
    end
    create_result = false
    if !params[:item][:assessment_result_id].blank? && @assessment_result = AssessmentResult.find(params[:item][:assessment_result_id])
      if @assessment_result.user.id == @user.id
        tr = @assessment_result.test_result
        tr.datestamp = Time.now
        tr.save!
      else
        create_result = true
      end
    else
      create_result = true
    end

    if create_result && params[:item][:assessment_id]
      @assessment_result = @user.assessment_results.create!(:assessment_id => params[:item][:assessment_id])
      TestResult.create!(:assessment_result_id => @assessment_result.id, :datestamp => Time.now)
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
            "candidate_response"=>@user_response
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
      irs = {
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
            "candidate_response"=>@user_response
          }
        }]
      }
      if @assessment_result
        irs[:user_id] = @user.id
        @item_result = @assessment_result.item_results.create(irs)
      else
        @item_result = @user.item_results.create!(irs)
      end
    end
    feedback = @item.feedback(@user_response)
    correct = @item.is_correct?(@user_response)

    if correct
      feedback = ['correct'] if feedback.empty?
      html_class = ''
      percent_correct = 100
    else
      feedback = ['incorrect'] if feedback.empty?
      html_class = ''
      percent_correct = 0
    end
    result = {
      :id => @item.id,
      :correct => correct,
      :percent_correct => percent_correct,
      :source => 'http://www.openassessments.com',
      :html => result_html(feedback, html_class)
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

  def result_html(feedback, html_class)
    html = ''
    feedback.each do |feedback|
      html += %Q{<div class="tooltip-inner #{feedback} #{html_class} ""><span class='result_words'>#{feedback}</span></div>}
    end
    html
  end

end
