require 'test_helper'

class DevelopsControllerTest < ActionController::TestCase
  setup do
    @develop = develops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:develops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create develop" do
    assert_difference('Develop.count') do
      post :create, develop: { boss: @develop.boss, coder: @develop.coder, name: @develop.name }
    end

    assert_redirected_to develop_path(assigns(:develop))
  end

  test "should show develop" do
    get :show, id: @develop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @develop
    assert_response :success
  end

  test "should update develop" do
    patch :update, id: @develop, develop: { boss: @develop.boss, coder: @develop.coder, name: @develop.name }
    assert_redirected_to develop_path(assigns(:develop))
  end

  test "should destroy develop" do
    assert_difference('Develop.count', -1) do
      delete :destroy, id: @develop
    end

    assert_redirected_to develops_path
  end
end
