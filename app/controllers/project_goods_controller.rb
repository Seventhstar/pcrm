class ProjectGoodsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]  
  before_action :logged_in_user
  before_action :check_sum, only: [:create,:update]

  def create
    @pe = ProjectGood.new(pg_params)
     respond_to do |format|
      # !@pe.new_date.nil? &&
        if @pe.save 
          format.html { redirect_to absences_url, notice: 'Менеджер успешно создан.' }
          format.json { render json: @pe.errors, status: :ok, location: @pe }
        else
          format.html { render :nothing => true }
          format.json { render json: @pe.errors, status: :unprocessable_entity }
        end
      end 
  end

  def destroy
    @pe.destroy
    respond_to do |format|
      format.html { redirect_to '/providers/', notice: 'Менеджер успешно удален.' }
      format.json { head :no_content }
    end
  end

   private

   def check_sum
      prms = ['gsum']
      prms.each do |p|
        pg_params[p] = pg_params[p].gsub!(' ','') if !pg_params[p].nil?
        # p p,project_params[p]
      end
    end

    def set_project
      @pe = ProjectGood.find(params[:id])
    end

    def pg_params
      prm = params.first[0] 
      params.require(prm).permit(:project_g_type_id,:provider_id,:date_supply,:currency_id,:gsum,:order,:name,:description)
    end
end
