class OptionsController < ApplicationController
 before_action :logged_in_user
 include OptionsHelper
  
  def _sort
    o = option_model.name
    case o
    when "Holiday"
        sort = :day
    else
        sort = :name 
    end
    # p "sort",sort
    @items = option_model.order(sort)
    @item = option_model.new
  end

  def index
    _sort
  end

  def create
    #p params[:options_page]
    @item = option_model.new(options_params)
    @items  = option_model.order(:name)  
    respond_to do |format|
       if @item.save
         format.json { render 'options/index', status: :created, location: @item, notice: 'Лид успешно создан.' }
       else
         format.json { render json: @item.errors, status: :unprocessable_entity }
       end
     end
  end

  def edit
    @page = params[:options_page]
    @page ||= "statuses"
    _sort
  end

  # DELETE /absences/1
  # DELETE /absences/1.json
  def destroy
    @item = option_model.find(params[:id])
    @item.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end  

  private
  # Never trust parameters from the scary internet, only allow the white list through.
    def options_params
      i = option_model.model_name.singular
      params.require(i).permit(:name,:actual,:day)
    end

    def option_model
      page = params[:options_page]
      page ||= "statuses"
      if page == "user_roles"
        @users = User.order('admin ASC,name')
        @roles = Role.order(:name)
      end
      page.classify.constantize
      
    end
end
