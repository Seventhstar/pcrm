class HistoryController < ApplicationController
  before_action :logged_in_user
  include CommonHelper

  def show
    if current_user.has_role?(:manager)
      @id = params[:id].try('to_i')
      @id = 0 if @id.nil?
      if @id > 0 
        @history = PaperTrail::Version.find(@id)
      end
    end
  end

  def index
    if current_user.has_role?(:manager)
      @types = [['Все', nil], ['Лиды', "Lead"], ['Проекты', 'Project'], ['Поступления', 'Receipt'],
                ['Поставщики', "Provider"], ['База знаний', 'WikiRecord'], ['Отсуствия', 'Absence'],
                ['Задачи на разработку', 'Develop']]
                
      @item_type = @types.detect{ |srch,_| srch == params['type'] }
      if !@item_type.nil? && !@item_type[1].nil? 
        @history = PaperTrail::Version.where(item_type: @item_type[1].classify ) 
      else 
        @history = PaperTrail::Version.all
      end 
      if !params['user_id'].nil? && params['user_id'].to_i>0 
        @history = @history.where(whodunnit: params['user_id'] ) 
      end

      if params[:search].present?
        @history.where('object_changes like ?', "%#{params[:search]}%" )
      end

      @history = @history.paginate(page: params[:page], per_page: 30).order('created_at DESC')
      @user_id = params['user_id']
    end
  end

end

