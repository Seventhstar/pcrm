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
      {id: 'footage', 
          name: 'Лиды: метраж', 
          column_header: 'Месяц',
          graph_header: 'Всего метраж по лидам',
          graph_header_2: 'Заключили договор на метраж'
        },
      {id: 'statuses', 
        name: 'Лиды: по статусам', 
        title: 'Количество и процент лидов по статусам', 
        two_columns: true},
      {id: 'absence', name: 'Отсутствия', model: 'absence',  column_header: 'Причина'}
       ]
  end

  def diagram_types
    [{id: 'Bar', name: 'Столбцы'}, {id: 'Donut', name: 'Круговая'}, {id: 'Area', name: 'График'}]
  end

  def show

    years = [2015, Date.today.year]
    @years = (years[0]..years[1]).map{|y| {id: y, name: y }}
    
    @cur_year = params[:year].nil? ? Date.today.year : params[:year].try(:to_i)
    @year = {id: @cur_year, name: @cur_year} 

    @chart_collection = chart_types.collect {|p| [ p[:name], p[:id] ] }
    @diagram_types    = diagram_types.collect {|p| [ p[:name], p[:id] ]}

    @page_type = params[:page_type].nil? ? "created_at": params[:page_type]

    @start_date = Date.new(@cur_year, 1, 1)
    @end_date   = @start_date.end_of_year

    @chart_type = chart_types.select{ |a| a[:id] == @page_type }.first

    
    title = @chart_type[:title]
    @page_header = title.nil? ? @chart_type[:name] : title

    @column_header = @chart_type[:column_header]
    
    @two_columns = @chart_type[:two_columns]
 
    if @chart_type[:model] == 'absence'
      @chart_data = Absence.counts_by_types(@page_type, @start_date, @end_date)
    else
      @chart_data = Lead.leads_users_count(@page_type, @start_date, @end_date, params[:diagram_type])
    end

    @chart_data[:xkey] = 'month' if !@chart_data.key?(:xkey)

    @diagram_type = params[:diagram_type].nil? ? @chart_data[:element] : params[:diagram_type]
    
  end
end

