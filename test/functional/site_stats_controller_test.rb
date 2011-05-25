require 'test_helper'

class SiteStatsControllerTest < ActionController::TestCase
  setup do
    @site_stat = site_stats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_stat" do
    assert_difference('SiteStat.count') do
      post :create, :site_stat => @site_stat.attributes
    end

    assert_redirected_to site_stat_path(assigns(:site_stat))
  end

  test "should show site_stat" do
    get :show, :id => @site_stat.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @site_stat.to_param
    assert_response :success
  end

  test "should update site_stat" do
    put :update, :id => @site_stat.to_param, :site_stat => @site_stat.attributes
    assert_redirected_to site_stat_path(assigns(:site_stat))
  end

  test "should destroy site_stat" do
    assert_difference('SiteStat.count', -1) do
      delete :destroy, :id => @site_stat.to_param
    end

    assert_redirected_to site_stats_path
  end
end
