class OptionsController < ApplicationController
  before_action :logged_in_user
  include OptionsHelper
  include RolesHelper

  def create_menu
    case option_model.name
    when "Holiday"
      @items = option_model.order('day desc')
    when "User"
      @only_actual = params[:only_actual].present? ? params[:only_actual]=='true' : true
      @items = option_model.only_actual(@only_actual)
                           .search(params[:search])
                           .order(:name)
    else
      @items = option_model.order(:name)
    end

    @item = option_model.new

    menu = UserOption::OPTIONS_MENU
    @menu_items = []
    managers_options = UserOption::MANAGER_ALLOW

    @menu = {}
    menu.each do |menu_group|
      menu_row = []
      menu_group[1].each do |menu_item|
        if is_admin? || managers_options.include?(menu_item)
          @menu_items << {id: menu_item, name: t(menu_item)[0]} 
          menu_row << menu_item 
        end
      end
      @menu[menu_group[0]] = menu_row if menu_row.length>0

    end
  end

  def index
    create_menu
  end

  def create
    @item  = option_model.new(options_params)
    @items = option_model.order(:name)  
    if @item.save
       else
        respond_to do |format|
         format.json { render json: @item.errors, status: :unprocessable_entity }
       end
     end
   end

   def edit
    @page = params[:options_page]
    @page ||= is_admin? ? "statuses" : "users"
    create_menu
  end

  def destroy
    @item = option_model.find(params[:id])
    @item.destroy
  end  

  private
    def options_params
      i = option_model.model_name.singular
      params.require(i).permit(:name,:actual,:day)
    end

    def option_model
      page = params[:options_page]
      page ||= is_admin? ? "statuses" : "users"

      if page == "user_roles"
        @users = User.order('admin ASC,name')
        @roles = Role.order(:name)
      end

      page.classify.constantize
    end
end
