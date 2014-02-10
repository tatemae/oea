require 'addressable/uri'

class OembedController < ApplicationController
  respond_to :json

  def endpoint
    url = Addressable::URI.parse(CGI.unescape(params[:url]))
    parts = Rails.application.routes.recognize_path(url.path, :method=>:get)
    controller = parts[:controller]
    id = parts[:id]

    case controller

    when 'assessments'
      assessment = Assessment.find(id, :include => :user)
      url = assessment_url(assessment.id, :embed => true).gsub('http:', '')
      width = 600
      height = assessment.recommended_height || 400
      result = {
          'version' => '1.0',
          'title' => assessment.title,
          'width' => width,
          'height' => height,
          'provider_name' => ENV['application_name'],
          'provider_url' => request.host_with_port,
          'type' => 'rich',
          'html' => embed_code(assessment)
      }

      if assessment.user.present?
        result['author_name'] = assessment.user.display_name
        result['author_url'] = user_url(assessment.user)
      end

      result
    end

    respond_with(result)
  end

end