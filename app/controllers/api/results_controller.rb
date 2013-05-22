class Api::ResultsController < ApplicationController
  def index
    results = ItemResult.all
    respond_to do |format|
      format.json { render json: results }
      format.csv { render text: results.to_csv }
    end
  end
end
