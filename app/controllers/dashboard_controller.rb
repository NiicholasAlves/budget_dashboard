class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @month = selected_month
    analyzer = BudgetAnalyzer.new(current_user, @month)

    @status_by_category = analyzer.status_by_category
    @summary = analyzer.overall_summary

    # Pie chart
    @pie_labels = @status_by_category.map { |row| row[:category].name }
    @pie_values = @status_by_category.map { |row| row[:spent].to_f }

    # Bar chart
    @bar_labels = @status_by_category.map { |row| row[:category].name }
    @bar_budget_values = @status_by_category.map { |row| row[:limit].to_f }
    @bar_spent_values  = @status_by_category.map { |row| row[:spent].to_f }
  end

  private

  def selected_month
    return Date.today.beginning_of_month unless params[:month].present?

    # params[:month] comes as "YYYY-MM"
    year, month = params[:month].split("-").map(&:to_i)

    Date.new(year, month, 1)
  rescue ArgumentError
    Date.today.beginning_of_month
  end
end
