class OptionsController < ApplicationController

 include OptionsHelper

 def edit

    if params[:options_page]
      @page_render = params[:options_page]+"/"+params[:options_page]
      @page_data = params[:options_page]
    else 
      @page_render = "statuses/statuses"
      @page_data = "statuses"
    end

    puts params[:options_page]
    case params[:options_page]
    when "channels"
      @items = Channel.order(:name)
      @item  = Channel.new
    when "statuses"
      @items  = Status.order(:name)  
      @item = Status.new
    when "budgets"
      @items = Budget.order(:name)  
      @item  = Budget.new
    when "styles"
      @items = Style.order(:name)
      @item  = Style.new
    when "goodstypes"
      @items = Goodstype.order(:name)
      @item  = Goodstype.new
    when "p_statuses"
      @items = PStatus.order(:name)
      @item  = PStatus.new
    when "dev_projects"
      @items = DevProject.order(:name)
      @item  = DevProject.new
    when "priorities"
      @items = Priority.order(:name)
      @item  = Priority.new      
    else
      puts "You gave me #{params[:options_page]} -- I have no idea what to do with that."
    end

    @statuses = Status.order(:name)
    @channels = Channel.order(:name)
    @styles   = Style.order(:name)
    @budgets  = Budget.order(:name)
    @goodstypes  = Goodstype.order(:name)
    @priorities = Priority.order(:name)


    @status = Status.new
    @channel = Channel.new
    @style = Style.new
    @budget = Budget.new
    @goodstype = Goodstype.new
    @priority  = Priority.new

  end


end
