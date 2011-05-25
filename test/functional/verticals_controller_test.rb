require 'test_helper'

class VerticalsControllerTest < ActionController::TestCase
  setup do
    @vertical = verticals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:verticals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vertical" do
    assert_difference('Vertical.count') do
      post :create, :vertical => @vertical.attributes
    end

    assert_redirected_to vertical_path(assigns(:vertical))
  end

  test "should show vertical" do
    get :show, :id => @vertical.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vertical.to_param
    assert_response :success
  end

  test "should update vertical" do
    put :update, :id => @vertical.to_param, :vertical => @vertical.attributes
    assert_redirected_to vertical_path(assigns(:vertical))
  end

  test "should destroy vertical" do
    assert_difference('Vertical.count', -1) do
      delete :destroy, :id => @vertical.to_param
    end

    assert_redirected_to verticals_path
  end
end
