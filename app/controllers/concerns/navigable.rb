module Navigable
  extend ActiveSupport::Concern

  private
    def main_params
      @years  = (2016..Date.today.year).map{|y| {id: y, name: y }}
      @years.push({id: 0, name: 'Все...'})
      cur_year = Date.today.year

      @cities = City.order(:id) if @cities.nil?
      @main_city = current_user.city if @main_city.nil? && !current_user.nil?
      
      cur_year = params[:year].nil? ? cur_year : params[:year].try(:to_i)
      @year = cur_year.class == Hash ? cur_year : {id: cur_year, name: cur_year}

      @cities = City.order(:id) if @cities.nil?
      @city   = params[:city].nil? ? @main_city&.id : params[:city]
    end
end