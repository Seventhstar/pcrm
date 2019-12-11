class StatisticsController < ApplicationController
  before_action :logged_in_user
  
  def chart_types
    [ {id: 'created_at', name: 'Лиды: по месяцам', column_header: 'Месяц'},
      {id: 'channels', name: 'Лиды: по каналам', column_header: 'Месяц'},
      {id: 'channels_donut', 
        name: 'Лиды: по каналам (круг)', 
        title: 'Количество и процент лидов по каналам', 
        two_columns: true
        },
      {id: 'users_created_at', name: 'Лиды: по сотрудникам', column_header: 'Месяц'},
      {id: 'footage', name: 'Лиды: метраж', column_header: 'Месяц'},
      {id: 'statuses', 
        name: 'Лиды: по статусам', 
        title: 'Количество и процент лидов по статусам', 
        two_columns: true},
      {id: 'absence', name: 'Отсутствия', model: 'absence',  column_header: 'Причина'}
       ]
  end

  def show
    years = [2015, Date.today.year]
    @years = (years[0]..years[1]).map{|y| {id: y, name: y }}
    cur_year = Date.today.year
    @year = {id: cur_year, name: cur_year} 

    @chart_collection = chart_types.collect {|p| [ p[:name], p[:id] ] }

    @page_type = params[:page_type].nil? ? "created_at": params[:page_type]

    @start_date = params[:start_date].nil? ? DateTime.now.at_beginning_of_year : Date.parse(params[:start_date])
    @end_date = params[:end_date].nil? ? DateTime.now.at_beginning_of_month : Date.parse(params[:end_date])
 
    chart_type = chart_types.select{ |a| a[:id] == @page_type }
    
    title = chart_type.first[:title]
    @page_header = title.nil? ? chart_type.first[:name] : title

    @column_header = chart_type.first[:column_header]
    
    @two_columns = chart_type.first[:two_columns]
 
    if chart_type.first[:model] == 'absence'
      @chart_data = Absence.counts_by_types(@page_type, @start_date, @end_date)
    else
      @chart_data = Lead.leads_users_count(@page_type, @start_date, @end_date)
    end

  end
end

