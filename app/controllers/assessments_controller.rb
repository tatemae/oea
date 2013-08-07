class AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  before_filter :authenticate_user!, only: [:create, :destroy]
  respond_to :html

  def index
    if params[:aid] && params[:src_url]
      @assessment = Assessment.find_by(src_url: params[:src_url], user_id: params[:aid])
      if @assessment
        redirect_to assessment_path(@assessment, :embed => true) and return
      end
    end
    if params[:user_id]
      user = User.find(params[:user_id])
      @assessments = user.assessments
    else
      @assessments = Assessment.all
    end
  end

  def show
    if !@assessment = Assessment.find(params[:id])
      redirect_to assessments_path
    end
    @items = @assessment.items.by_oldest
    if params[:item]
      @item = Item.find(params[:item])
    else
      @item = @items.first
    end

    @display_embed_code = params[:embed] != "true"

    if @assessment.src_url
      @embed_code = CGI.unescapeHTML("<iframe src='//#{request.host_with_port}#{assessments_path}?embed=true&aid=#{@assessment.user_id}&src_url=#{@assessment.src_url}' frameborder='0' width='600' height='500' ></iframe>")
    else
      @embed_code = CGI.unescapeHTML("<iframe src='//#{request.host_with_port}#{assessment_path(@assessment)}?embed=true' frameborder='0' width='600' height='500' ></iframe>")
    end

    create_item_result(@item)

    @question_count = @items.count
    @current_index = @items.index(@item)
    @prev_item = @current_index == 0 ? nil : @items[@current_index-1]
    @next_item = @current_index == @question_count-1 ? nil : @items[@current_index+1]

    respond_to do |format|
      format.html { render :layout => params[:embed] == "true" ? 'bare' : 'application' }
    end
  end

  def new
  end

  def assessment_from_params(params)
    
    if params.has_key?(:src_url)
      src_url = params[:src_url]

      assessment = Assessment.find_by(src_url: src_url, user_id: current_user.id)
      return assessment if assessment

      xml = Net::HTTP.get(URI.parse(src_url))
    
    elsif params.has_key?(:xml_file)
      xml = params[:xml_file].read 
    end
    
    Assessment.from_xml(xml, current_user, src_url)
  end

  def create
    respond_with(assessment_from_params(params[:assessment]))
  end

  def destroy
    @assessment = Assessment.find(params[:id])
    @assessment.destroy
    respond_to do |format|
      format.html { redirect_to(assessments_url) }
    end
  end

end
