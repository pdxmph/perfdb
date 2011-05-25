require 'test_helper'

class VerticalTeamsControllerTest < ActionController::TestCase
  setup do
    @vertical_team = vertical_teams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vertical_teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vertical_team" do
    assert_difference('VerticalTeam.count') do
      post :create, :vertical_team => @vertical_team.attributes
    end

    assert_redirected_to vertical_team_path(assigns(:vertical_team))
  end

  test "should show vertical_team" do
    get :show, :id => @vertical_team.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vertical_team.to_param
    assert_response :success
  end

  test "should update vertical_team" do
    put :update, :id => @vertical_team.to_param, :vertical_team => @vertical_team.attributes
    assert_redirected_to vertical_team_path(assigns(:vertical_team))
  end

  test "should destroy vertical_team" do
    assert_difference('VerticalTeam.count', -1) do
      delete :destroy, :id => @vertical_team.to_param
    end

    assert_redirected_to vertical_teams_path
  end
end
