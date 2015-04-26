require 'test_helper'

class DevProjectsControllerTest < ActionController::TestCase
  setup do
    @dev_project = dev_projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dev_projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dev_project" do
    assert_difference('DevProject.count') do
      post :create, dev_project: { name: @dev_project.name, priority_id: @dev_project.priority_id }
    end

    assert_redirected_to dev_project_path(assigns(:dev_project))
  end

  test "should show dev_project" do
    get :show, id: @dev_project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dev_project
    assert_response :success
  end

  test "should update dev_project" do
    patch :update, id: @dev_project, dev_project: { name: @dev_project.name, priority_id: @dev_project.priority_id }
    assert_redirected_to dev_project_path(assigns(:dev_project))
  end

  test "should destroy dev_project" do
    assert_difference('DevProject.count', -1) do
      delete :destroy, id: @dev_project
    end

    assert_redirected_to dev_projects_path
  end
end
