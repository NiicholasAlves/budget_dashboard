class BudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_budget, only: %i[ show edit update destroy ]

  def index
    @budgets = current_user.budgets.includes(:category).order(month: :desc)
  end

  def show
  end

  def new
    @budget = current_user.budgets.build(month: Date.today.beginning_of_month)
  end

  def edit
  end

  def create
    @budget = current_user.budgets.build(budget_params)

    respond_to do |format|
      if @budget.save
        format.html { redirect_to @budget, notice: "Budget was successfully created." }
        format.json { render :show, status: :created, location: @budget }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @budget.update(budget_params)
        format.html { redirect_to @budget, notice: "Budget was successfully updated." }
        format.json { render :show, status: :ok, location: @budget }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @budget.destroy
    respond_to do |format|
      format.html { redirect_to budgets_url, notice: "Budget was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_budget
      @budget = current_user.budgets.find(params[:id])
    end

    def budget_params
      params.require(:budget).permit(:month, :limit_amount, :category_id)
    end
end
