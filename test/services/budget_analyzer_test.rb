require "test_helper"

class BudgetAnalyzerTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      email: "budget_test_#{SecureRandom.hex(4)}@example.com",
      password: "password123"
    )

    @category = Category.create!(
      name: "Groceries",
      user: @user
    )

    @month = Date.new(2025, 1, 1)

    Budget.create!(
      user: @user,
      category: @category,
      month: @month,
      limit_amount: 500
    )

    Expense.create!(
      user: @user,
      category: @category,
      spent_on: Date.new(2025, 1, 10),
      amount: 200,
      description: "Weekly shop"
    )
  end

  test "calculates total spent correctly" do
    analyzer = BudgetAnalyzer.new(@user, @month)
    summary = analyzer.overall_summary

    assert_equal 200, summary[:total_spent]
  end

  test "calculates remaining budget correctly" do
    analyzer = BudgetAnalyzer.new(@user, @month)
    summary = analyzer.overall_summary

    assert_equal 300, summary[:remaining]
  end

  test "calculates percentage of budget used correctly" do
    analyzer = BudgetAnalyzer.new(@user, @month)
    summary = analyzer.overall_summary

    assert_equal 40, summary[:percent]
  end

  test "assigns OK status when spending is within budget" do
    analyzer = BudgetAnalyzer.new(@user, @month)
    categories = analyzer.status_by_category

    groceries = categories.find { |c| c[:category].name == "Groceries" }

    assert_equal :ok, groceries[:status]
  end
end
