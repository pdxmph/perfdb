require 'test_helper'

class ArtilcesControllerTest < ActionController::TestCase
  setup do
    @artilce = artilces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artilces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create artilce" do
    assert_difference('Artilce.count') do
      post :create, :artilce => @artilce.attributes
    end

    assert_redirected_to artilce_path(assigns(:artilce))
  end

  test "should show artilce" do
    get :show, :id => @artilce.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @artilce.to_param
    assert_response :success
  end

  test "should update artilce" do
    put :update, :id => @artilce.to_param, :artilce => @artilce.attributes
    assert_redirected_to artilce_path(assigns(:artilce))
  end

  test "should destroy artilce" do
    assert_difference('Artilce.count', -1) do
      delete :destroy, :id => @artilce.to_param
    end

    assert_redirected_to artilces_path
  end
end
