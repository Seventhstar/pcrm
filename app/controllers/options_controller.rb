class OptionsController < ApplicationController

 def edit

    if params[:options_page]
      @page_render = params[:options_page]+"/"+params[:options_page]
      @page_data = params[:options_page]
    else 
      @page_render = "statuses/statuses"
      @page_data = "statuses"
    end

    @statuses = Status.all
    @channels = Channel.all
    @styles   = Style.all
    @budgets  = Budget.all

    @status = Status.new
    @channel = Channel.new
    @style = Style.new
    @budget = Budget.new
  end

end
