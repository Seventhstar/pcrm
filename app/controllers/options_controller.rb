class OptionsController < ApplicationController
 before_action :logged_in_user
 include OptionsHelper
  
  def index
    @items = params[:options_page].classify.constantize.order(:name)
    @item = params[:options_page].classify.constantize.new
  end

 def edit
    if params[:options_page]
      @page_data = params[:options_page]
    else 
      @page_data = "statuses"
    end
    @items = params[:options_page].classify.constantize.order(:name)
    @item = params[:options_page].classify.constantize.new
  end

  # DELETE /absences/1
  # DELETE /absences/1.json
  def destroy
    @item = params[:options_page].classify.constantize.find(params[:id])
    @item.destroy
    respond_to do |format|
      format.html { redirect_to params[:options_page], notice: 'Отсутствие успешно удалено.' }
      format.json { head :no_content }
    end
  end  

end
