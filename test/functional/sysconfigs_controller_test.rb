require 'test_helper'

class SysconfigsControllerTest < ActionController::TestCase
  setup do
    @sysconfig = sysconfigs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sysconfigs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sysconfig" do
    assert_difference('Sysconfig.count') do
      post :create, :sysconfig => @sysconfig.attributes
    end

    assert_redirected_to sysconfig_path(assigns(:sysconfig))
  end

  test "should show sysconfig" do
    get :show, :id => @sysconfig.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sysconfig.to_param
    assert_response :success
  end

  test "should update sysconfig" do
    put :update, :id => @sysconfig.to_param, :sysconfig => @sysconfig.attributes
    assert_redirected_to sysconfig_path(assigns(:sysconfig))
  end

  test "should destroy sysconfig" do
    assert_difference('Sysconfig.count', -1) do
      delete :destroy, :id => @sysconfig.to_param
    end

    assert_redirected_to sysconfigs_path
  end
end
