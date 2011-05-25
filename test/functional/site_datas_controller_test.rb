require 'test_helper'

class SiteDatasControllerTest < ActionController::TestCase
  setup do
    @site_data = site_datas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_datas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_data" do
    assert_difference('SiteData.count') do
      post :create, :site_data => @site_data.attributes
    end

    assert_redirected_to site_data_path(assigns(:site_data))
  end

  test "should show site_data" do
    get :show, :id => @site_data.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @site_data.to_param
    assert_response :success
  end

  test "should update site_data" do
    put :update, :id => @site_data.to_param, :site_data => @site_data.attributes
    assert_redirected_to site_data_path(assigns(:site_data))
  end

  test "should destroy site_data" do
    assert_difference('SiteData.count', -1) do
      delete :destroy, :id => @site_data.to_param
    end

    assert_redirected_to site_datas_path
  end
end
