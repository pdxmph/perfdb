require 'test_helper'

class ContentSourcesControllerTest < ActionController::TestCase
  setup do
    @content_source = content_sources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:content_sources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create content_source" do
    assert_difference('ContentSource.count') do
      post :create, :content_source => @content_source.attributes
    end

    assert_redirected_to content_source_path(assigns(:content_source))
  end

  test "should show content_source" do
    get :show, :id => @content_source.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @content_source.to_param
    assert_response :success
  end

  test "should update content_source" do
    put :update, :id => @content_source.to_param, :content_source => @content_source.attributes
    assert_redirected_to content_source_path(assigns(:content_source))
  end

  test "should destroy content_source" do
    assert_difference('ContentSource.count', -1) do
      delete :destroy, :id => @content_source.to_param
    end

    assert_redirected_to content_sources_path
  end
end
