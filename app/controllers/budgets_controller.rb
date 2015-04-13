class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  # GET /budgets
  # GET /budgets.json
  def index
    @budgets = Budget.order(:name)
    @budget =  Budget.new

    @items  = Budget.order(:name)  
    @item = Budget.new
  end

  # GET /budgets/1
  # GET /budgets/1.json
  def show
    @style = Style.find(params[:id])
  end

  # GET /budgets/new
  def new
    @budgets = Budget.order(:name)
    @budget = Budget.new
  end

  # GET /budgets/1/edit
  def edit
  end

  # POST /budgets
  # POST /budgets.json
  def create
    @budget = Budget.new(budget_params)

    respond_to do |format|
      if @budget.save
        format.html { redirect_to '/options/budgets', notice: 'Бюджет успешно создан.' }
        format.json { render :index, status: :created, location: @budget }
      else
        format.html { render :new }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /budgets/1
  # PATCH/PUT /budgets/1.json
  def update
    respond_to do |format|
      if @budget.update(budget_params)
        format.html { redirect_to '/options/budgets', notice: 'Бюджет успешно обновлен' }
        format.json { render :show, status: :ok, location: @budget }
      else
        format.html { render :edit }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
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
