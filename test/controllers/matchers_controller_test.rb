require 'test_helper'

class MatchersControllerTest < ActionController::TestCase
  setup do
    @matcher = matchers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:matchers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create matcher" do
    assert_difference('Matcher.count') do
      post :create, matcher: { code: @matcher.code, max_args: @matcher.max_args, min_args: @matcher.min_args }
    end

    assert_redirected_to matcher_path(assigns(:matcher))
  end

  test "should show matcher" do
    get :show, id: @matcher
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @matcher
    assert_response :success
  end

  test "should update matcher" do
    patch :update, id: @matcher, matcher: { code: @matcher.code, max_args: @matcher.max_args, min_args: @matcher.min_args }
    assert_redirected_to matcher_path(assigns(:matcher))
  end

  test "should destroy matcher" do
    assert_difference('Matcher.count', -1) do
      delete :destroy, id: @matcher
    end

    assert_redirected_to matchers_path
  end
end
