class HistoryController < ApplicationController
  before_action :logged_in_user
  include CommonHelper

  
  def show
    @h = PaperTrail::Version.where(item_type: 'Lead').paginate(:page => params[:page], :per_page => 30).order('created_at DESC') #order(created_at: :desc).limit(50) #get_all_history
    @types = [['Все', ""], ['Лиды', "Lead"], ['Поставщики', "Providers"]]
  end
end

