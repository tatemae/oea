class ItemResultsController < ApplicationController
  respond_to :json

  def create
    respond_to do |format|
      format.json do
        @item_result = ItemResult.create!(:identifier => params[:identifier], :item_id => params[:item_id], :datestamp => Time.now, :referer => request.referer, :ip_address => request.ip)
        respond_with(@item_result)
      end
    end
  end
end
