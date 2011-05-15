require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup do
    stub_current_user
  end

  test "should get welcome" do
    get :welcome
    assert_response :success
  end

  test "should route to welcome" do
    assert_routing welcome_path, { :controller => "pages", :action => "welcome" }
    assert_routing '/welcome', { :controller => "pages", :action => "welcome" }
  end
  
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should route to home" do
    assert_routing home_path, { :controller => "pages", :action => "home" }
    assert_routing '/home', { :controller => "pages", :action => "home" }
  end

  test "home should assign friends" do
    get :home
    assert_not_nil assigns[:friends]
  end
end
