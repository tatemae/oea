class AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  before_filter :authenticate_user!, only: [:create, :destroy]
  respond_to :html

  def index
    if params[:aid] && params[:src_url]
      @assessment = assessment_from_url(params[:src_url], params[:aid].to_i)
      if @assessment
        redirect_to assessment_path(@assessment, :embed => true) and return
      end
    end
    if current_user && current_user.id.to_s == params[:user_id]
      @assessments = current_user.assessments
    else
      redirect_to '/'
    end
  end

  def show
    if !@assessment = Assessment.find(params[:id])
      redirect_to assessments_path
    end

    if params[:embed].blank?
      @items = @assessment.items.by_oldest
      if params[:item]
        @item = Item.find(params[:item])
      else
        @item = @items.first
      end

      @display_embed_code = true

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
    end

    respond_to do |format|
      format.html { render :layout => params[:embed] == "true" ? 'bare' : 'application' }
    end
  end

  def new
  end

  def assessment_from_url(src_url, author_id)

    src_uri = URI.parse(src_url)
    http = Net::HTTP.new(src_uri.host, src_uri.port)
    if src_url.starts_with?('https')
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request = Net::HTTP::Get.new(src_uri)
    response = http.request(request)
    xml = response.body

    published_at = DateTime.parse(response['date']) rescue nil

    assessment = Assessment.find_by(src_url: src_url, user_id: current_user.id)

    return assessment if assessment && (published_at.blank? || assessment.published_at.blank? || assessment.published_at >= published_at)

    Assessment.from_xml(xml, current_user, src_url, published_at)
  end

  def assessment_from_file(file)
    xml = file.read
    Assessment.from_xml(xml, current_user)
  end

  def create
    assessment_params = params[:assessment]
    if assessment_params.has_key?(:xml_file)
      respond_with(assessment_from_file(assessment_params[:xml_file]))
    elsif assessment_params[:src_url]
      respond_with(assessment_from_url(assessment_params[:src_url], current_user.id))
    end


  end

  def destroy
    @assessment = Assessment.find(params[:id])
    @assessment.destroy
    respond_to do |format|
      format.html { redirect_to(user_assessments_url(current_user)) }
    end
  end

end
