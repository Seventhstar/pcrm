require 'test_helper'

class LeadsCommentsControllerTest < ActionController::TestCase
  setup do
    @leads_comment = leads_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:leads_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create leads_comment" do
    assert_difference('LeadsComment.count') do
      post :create, leads_comment: { comment: @leads_comment.comment, user_id: @leads_comment.user_id }
    end

    assert_redirected_to leads_comment_path(assigns(:leads_comment))
  end

  test "should show leads_comment" do
    get :show, id: @leads_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @leads_comment
    assert_response :success
  end

  test "should update leads_comment" do
    patch :update, id: @leads_comment, leads_comment: { comment: @leads_comment.comment, user_id: @leads_comment.user_id }
    assert_redirected_to leads_comment_path(assigns(:leads_comment))
  end

  test "should destroy leads_comment" do
    assert_difference('LeadsComment.count', -1) do
      delete :destroy, id: @leads_comment
    end

    assert_redirected_to leads_comments_path
  end
end
