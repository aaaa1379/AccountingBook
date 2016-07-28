require 'test_helper'

class DoomExpensesControllerTest < ActionController::TestCase
  setup do
    @doom_expense = doom_expenses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:doom_expenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create doom_expense" do
    assert_difference('DoomExpense.count', 1) do
      post :create, doom_expense: { expense: @doom_expense.expense, income: @doom_expense.income, item: @doom_expense.item, note: @doom_expense.note}
    end
    assert_redirected_to doom_expenses_path
  end

  # test "should show doom_expense" do
  #   get :show, id: @doom_expense
  #   assert_response :success
  # end

  test "should get edit" do
    get :edit, id: @doom_expense
    assert_response :success
  end

  test "should update doom_expense" do
    patch :update, id: @doom_expense, doom_expense: { note: @doom_expense.note }
    #assert_redirected_to doom_expenses_path
    assert_response :success
  end

  test "should destroy doom_expense" do
    assert_difference('DoomExpense.count', 0) do
      delete :destroy, id: @doom_expense
    end

    assert_redirected_to doom_expenses_path
  end
end
