class OptionsController < ApplicationController
 before_action :logged_in_user
 include OptionsHelper

 def edit

    if params[:options_page]
      @page_render = params[:options_page]+"/"+params[:options_page]
      @page_data = params[:options_page]
    else 
      @page_render = "statuses/statuses"
      @page_data = "statuses"
    end

    @items = params[:options_page].classify.constantize.order(:name)
    @item = params[:options_page].classify.constantize.new

#    @statuses = Status.order(:name)
#    @channels = Channel.order(:name)
 #   @styles   = Style.order(:name)
 #   @budgets  = Budget.order(:name)
 ##   @goodstypes  = Goodstype.order(:name)
  #  @priorities = Priority.order(:name)

#
##    @status = Status.new
 #   @channel = Channel.new
 #   @style = Style.new
 #   @budget = Budget.new
 #   @goodstype = Goodstype.new
 #   @priority  = Priority.new

  end


end
