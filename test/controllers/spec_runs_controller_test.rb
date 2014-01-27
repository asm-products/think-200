require 'test_helper'

class SpecRunsControllerTest < ActionController::TestCase
  setup do
    @spec_run = spec_runs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spec_runs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spec_run" do
    assert_difference('SpecRun.count') do
      post :create, spec_run: { passed: @spec_run.passed, project_id: @spec_run.project_id, raw_data: @spec_run.raw_data }
    end

    assert_redirected_to spec_run_path(assigns(:spec_run))
  end

  test "should show spec_run" do
    get :show, id: @spec_run
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spec_run
    assert_response :success
  end

  test "should update spec_run" do
    patch :update, id: @spec_run, spec_run: { passed: @spec_run.passed, project_id: @spec_run.project_id, raw_data: @spec_run.raw_data }
    assert_redirected_to spec_run_path(assigns(:spec_run))
  end

  test "should destroy spec_run" do
    assert_difference('SpecRun.count', -1) do
      delete :destroy, id: @spec_run
    end

    assert_redirected_to spec_runs_path
  end
end
