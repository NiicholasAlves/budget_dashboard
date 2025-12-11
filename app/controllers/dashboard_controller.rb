class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.today.beginning_of_month
    analyzer = BudgetAnalyzer.new(current_user, @month)

    @status_by_category = analyzer.status_by_category
    @summary = analyzer.overall_summary
  end
end
