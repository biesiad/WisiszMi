require 'test_helper'

class DebtsControllerTest < ActionController::TestCase
  setup do
    request.env["HTTP_REFERER"] = debts_path
    stub_current_user
    @debt = debts(:from1_to2)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:friends)
  end

  test "should create debt" do
    assert_difference('Debt.count') do
      debt = Debt.new(:user_from_id => 1, :user_to_id => 2, :description => "desc", :value => 12)
      post :create, :debt => debt.attributes
    end
  end

  test "should show debt" do
    get :show, :id => @debt.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @debt.to_param
    assert_response :success
  end

  test "should update debt" do
    put :update, :id => @debt.to_param, :debt => @debt.attributes
    assert_redirected_to debt_path(assigns(:debt))
  end

  test "should destroy debt" do
    assert_difference('Debt.count', -1) do
      delete :destroy, :id => @debt.to_param
    end

    assert_redirected_to debts_path
  end

  test "should get search" do
    post :search
    assert_response :success
  end

  test "should assign @friends" do
    post :search
    assert_not_nil assigns(:friends)
  end

  test "should render index template" do
    post :search
    assert_template :index
  end
end
