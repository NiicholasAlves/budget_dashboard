# app/lib/budget_analyzer.rb
class BudgetAnalyzer
  # month should be a Date (e.g. Date.today.beginning_of_month)
  def initialize(user, month)
    @user = user
    @month = month.beginning_of_month
  end

  # returns a hash { category_id => total_spent (as decimal) }
  def totals_by_category
    expenses_in_month
      .group(:category_id)
      .sum(:amount) # ActiveRecord returns BigDecimal
  end

  # returns an array of hashes with status per budget
  def status_by_category
    result = []

    budgets_for_month.includes(:category).each do |budget|
      spent = totals_by_category[budget.category_id] || 0
      limit = budget.limit_amount || 0
      remaining = limit - spent
      percent = limit.to_f > 0 ? ((spent.to_f / limit.to_f) * 100).round : 0

      status =
        if spent > limit
          :over
        elsif percent >= 70
          :warning
        else
          :ok
        end

      result << {
        category: budget.category,
        limit: limit,
        spent: spent,
        remaining: remaining,
        percent: percent,
        status: status
      }
    end

    result
  end

  def overall_summary
    total_limit = budgets_for_month.sum(:limit_amount) || 0
    total_spent = expenses_in_month.sum(:amount) || 0
    remaining   = total_limit - total_spent
    percent     = total_limit.to_f > 0 ? ((total_spent.to_f / total_limit.to_f) * 100).round : 0

    {
      total_limit: total_limit,
      total_spent: total_spent,
      remaining: remaining,
      percent: percent
    }
  end

  private

  def budgets_for_month
    @user.budgets.where(month: @month..@month.end_of_month)
  end

  def expenses_in_month
    @user.expenses.where(spent_on: @month..@month.end_of_month)
  end
end
