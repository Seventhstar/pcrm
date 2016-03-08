class HistoryController < ApplicationController
  before_action :logged_in_user
  include CommonHelper

  
  def show
    @types = [['Все', nil], ['Лиды', "Lead"], ['Проекты','Project'], ['Поступления','Receipt'],['Поставщики', "Provider"], ['База знаний','WikiRecord'],['Задачи на разработку','Develop']]
    @item_type = @types.detect{ |srch,_| srch == params['type'] }
    if !@item_type.nil? && !@item_type[1].nil? 
      @history = PaperTrail::Version.where(item_type: @item_type[1].classify ) #order(created_at: :desc).limit(50) #get_all_history
    else 
      @history = PaperTrail::Version.all
    end 
    if !params['user_id'].nil? && params['user_id'].to_i>0 
      @history = @history.where(whodunnit: params['user_id'] ) 
    end
    @history = @history.paginate(:page => params[:page], :per_page => 30).order('created_at DESC')
    @user_id = params['user_id']
    
  end
end

