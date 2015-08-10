class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  # GET /budgets
  # GET /budgets.json
  def index

    @items  = Budget.order(:name)  
    @item = Budget.new

  end


  # POST /budgets
  # POST /budgets.json
  def create
    @item = Budget.new(budget_params)
    @items  = Budget.order(:name)  
    respond_to do |format|
      if @item.save
        format.html { redirect_to '/options/budgets', notice: 'Бюджет успешно создан.' }
        format.json { render 'options/index', status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /budgets/1
  # DELETE /budgets/1.json
  def destroy
    @budget.destroy
    respond_to do |format|
      format.html { redirect_to '/options/budgets', notice: 'Бюджет успешно удален.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      @budget = Budget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_params
      params.require(:budget).permit(:name)
    end
end
