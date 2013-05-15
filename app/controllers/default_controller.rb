class DefaultController < ApplicationController
  def index
  	@item = JSON(File.open("#{Rails.root}/app/assets/item1.json").read)
  end
end
