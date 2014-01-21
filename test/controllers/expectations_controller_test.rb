require 'test_helper'

class ExpectationsControllerTest < ActionController::TestCase
  setup do
    @expectation = expectations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expectations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expectation" do
    assert_difference('Expectation.count') do
      post :create, expectation: { expectation: @expectation.expected, matcher_id: @expectation.matcher_id, requirement_id: @expectation.requirement_id, subject: @expectation.subject }
    end

    assert_redirected_to expectation_path(assigns(:expectation))
  end

  test "should show expectation" do
    get :show, id: @expectation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @expectation
    assert_response :success
  end

  test "should update expectation" do
    patch :update, id: @expectation, expectation: { expectation: @expectation.expected, matcher_id: @expectation.matcher_id, requirement_id: @expectation.requirement_id, subject: @expectation.subject }
    assert_redirected_to expectation_path(assigns(:expectation))
  end

  test "should destroy expectation" do
    assert_difference('Expectation.count', -1) do
      delete :destroy, id: @expectation
    end

    assert_redirected_to expectations_path
  end
end
