class HistoryController < ApplicationController
  before_action :logged_in_user
  include CommonHelper
  
  def show
    @h = get_all_history
  end
end

