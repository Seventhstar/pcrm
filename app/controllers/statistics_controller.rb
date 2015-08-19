class StatisticsController < ApplicationController
  before_action :logged_in_user
  
  def show

    @page_type = params[:page_type].nil? ? "created_at": params[:page_type]

    @start_date = params[:start_date].nil? ? DateTime.now.at_beginning_of_month - 3.months : Date.parse(params[:start_date])
    @end_date = params[:end_date].nil? ? DateTime.now.at_beginning_of_month : Date.parse(params[:end_date])

    @leads_count = Lead.leads_users_count(@page_type,@start_date,@end_date)
    
    @page_header = case @page_type
    when 'created_at'
    	'Создано лидов'
    when 'footage'
    	'Метраж объектов'
    when 'users_created_at'
    	'Лидов создано сотрудниками'
    when 'statuses'
       @two_columns = true 
      'Количество и процент лидов по статусам'      
    end 
  end
end

