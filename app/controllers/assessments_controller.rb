require 'open-uri'

class AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :skip_trackable
  before_filter :authenticate_user!, only: [:new, :create, :destroy]
  load_and_authorize_resource except: [:index, :show, :create]

  respond_to :html

  def index
    if params[:user_id].present?
      @assessments = User.find(params[:user_id]).assessments
    else
      @assessments = Assessment.all
    end
  end

  def show
    @embedded = params[:src_url].present? || params[:embed].present?
    @confidence_levels = params[:confidence_levels] ? true : false
    @enable_start = params[:enable_start] ? true : false
    @eid = params[:eid] if params[:eid]
    @keywords = params[:keywords] if params[:keywords]
    @external_user_id = params[:external_user_id] if params[:external_user_id]
    @results_end_point = ensure_scheme(params[:results_end_point]) if params[:results_end_point].present?
    if params[:id].present? && !['load', 'offline'].include?(params[:id])
      @assessment = Assessment.find(params[:id])
      @eid ||= @assessment.identifier
      if @embedded
        # Just show the assessment. This is here to support old style embed with id=# and embed=true
        @src_url = embed_url(@assessment)
      else
        # Show the full page with analtyics and embed code buttons
        @embed_code = embed_code(@assessment, @confidence_levels, @eid, @enable_start, params[:offline].present?)
        @embed_code_confidence_levels = embed_code(@assessment, true, @eid, @enable_start)
      end
    else
      # Get the remote url where we can download the qti
      @src_url = ensure_scheme(URI.decode(params[:src_url])) if params[:src_url].present?
    end

    @assessment_id = @assessment ? @assessment.id : params[:assessment_id] || 'null'

    if params[:offline].present? && @src_url.present?
      @src_data = open(@src_url).read
      xml = EdxSequentialParser.parse(@src_data)
      # edX
      if defined?(xml.verticals)
        base_uri = @src_url[0, @src_url.index('sequential')];
        @edx_verticals = crawlEdx(base_uri, 'vertical', xml.verticals.map(&:url_name))
        @edx_problems = {}
        @edx_verticals.each do |id, vertical|
          xml = EdxVerticalParser.parse(vertical)
          @edx_problems.merge!(crawlEdx(base_uri, 'problem', xml.problems.map(&:url_name)))
        end
      end
    end

    respond_to do |format|
      format.html { render :layout => @embedded ? 'bare' : 'application' }
    end
  end

  def new
  end

  def create
    xml = assessment_params[:xml_file].read
    @assessment = Assessment.from_xml(xml, current_user)
    @assessment.title = assessment_params[:title] if assessment_params[:title].present?
    @assessment.description = assessment_params[:description] if assessment_params[:description].present?
    @assessment.license = assessment_params[:license] if assessment_params[:license].present?
    @assessment.keyword_list.add(assessment_params[:keywords], parse: true) if assessment_params[:keywords].present?
    @assessment.save!
    respond_with(@assessment)
  end

  def destroy
    @assessment.destroy
    respond_to do |format|
      format.html { redirect_to(user_assessments_url(current_user)) }
    end
  end

  private

    def crawlEdx(base_uri, type, ids)
      ids.inject({}) do |hsh, id|
        hsh[id] = open(base_uri + type + '/' + id + '.xml').read
        hsh
      end
    end

    def assessment_params
      params.require(:assessment).permit(:title, :description, :xml_file, :license, :keywords)
    end

end
