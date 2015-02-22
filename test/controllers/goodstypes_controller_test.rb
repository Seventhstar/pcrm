require 'test_helper'

class GoodstypesControllerTest < ActionController::TestCase
  setup do
    @goodstype = goodstypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:goodstypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create goodstype" do
    assert_difference('Goodstype.count') do
      post :create, goodstype: { name: @goodstype.name }
    end

    assert_redirected_to goodstype_path(assigns(:goodstype))
  end

  test "should show goodstype" do
    get :show, id: @goodstype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @goodstype
    assert_response :success
  end

  test "should update goodstype" do
    patch :update, id: @goodstype, goodstype: { name: @goodstype.name }
    assert_redirected_to goodstype_path(assigns(:goodstype))
  end

  test "should destroy goodstype" do
    assert_difference('Goodstype.count', -1) do
      delete :destroy, id: @goodstype
    end

    assert_redirected_to goodstypes_path
  end
end
