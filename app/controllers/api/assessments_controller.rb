class Api::AssessmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    render nothing: true
  end

  def create
    render nothing: true
  end
end
