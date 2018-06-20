require 'test_helper'

class NewsControllerTest < ActionController::TestCase
  test "should get news" do
    get :news
    assert_response :success
  end

  test "should get branches" do
    get :branches
    assert_response :success
  end

  test "should get authors" do
    get :authors
    assert_response :success
  end

end
