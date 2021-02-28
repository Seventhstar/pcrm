class OptionsController < ApplicationController
  before_action :logged_in_user
  include OptionsHelper
  include RolesHelper

  def create_menu

    attrs_except = []
    # puts "option_model.name #{option_model.name}"
    case option_model.name
    when "Holiday"
      @items = option_model.order('day desc')
    when "User"
      @only_actual = params[:only_actual].present? ? params[:only_actual] == 'true' : true

      @items = option_model.only_actual(@only_actual)
                           .search(params[:search])
                           .order(:name)
    when "ProjectStage"
      @items = option_model.joins(:project_type).order([:project_type_id, :stage_order]).to_a.group_by(&:project_type_name)
      attrs_except = "project_type_id"
    when "UserRole"
      @items = option_model.joins(:user)
      # @roles = Role.order(:name)
    else
      @items = option_model.order(:name)
    end

    @items = {'' => @items} if !@items.is_a?(Hash)

    @item = option_model.new
    

    #@attributes = (@items.first.nil? ? @item : @items.first[1][0]).attributes.except("id", "created_at", "updated_at")
    @attributes = []
    option_model.columns.each_with_object({}) do |c, attrs|
      #unless reject_col?(c)
        name = c.name.to_sym
        puts "name #{name} - #{name.to_s =='id'}"
        @attributes << [name.to_s] if !["id", "created_at", "updated_at"].include?(name.to_s)
      #end
    end





    @attributes.delete(attrs_except) 


    menu = UserOption::OPTIONS_MENU
    @menu_items       = []
    managers_options  = UserOption::MANAGER_ALLOW

    @menu = {}
    menu.each do |menu_group|
      menu_row = []
      menu_group[1].each do |menu_item|
        if is_admin? || managers_options.include?(menu_item)
          @menu_items << {id: menu_item, name: t(menu_item)[0]} 
          menu_row << menu_item 
        end
      end
      @menu[menu_group[0]] = menu_row if menu_row.length > 0

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
      params.require(i).permit(:name, :actual, :day, :project_type_id)
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
