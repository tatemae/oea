class ItemResultsController < ApplicationController
  def index
    @item = Item.find(params[:item_id])
    @item_results = @item.item_results
    @renders = @item_results.count
    @submitted = @item_results.by_status_final
    @users = []
    @referers = []
    @correct = []
    @item_results.map do |ir|
      @users << ir.user if !@users.include?(ir.user)
      @referers << ir.referer if !ir.referer.nil? && !@referers.include?(ir.referer)
      @correct << ir if ir.item_variable && ir.item_variable.map { |iv| iv["response_variable"]["correct_response"].to_i == iv["response_variable"]["candidate_response"].to_i }.any?
    end
    @percent_correct = @submitted.count > 0 ? @correct.count.to_f / @submitted.count.to_f : 0
  end
end
