require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UsersControllerTest < ActionController::TestCase

  def setup
    @controller = Admin::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login users(:admin)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_user
    assert_difference('User.count') do
      post :create, :user => { :openid_url => "http://abc.example.com",
        :display_name => "New User", :email_address => "abc@example.com" }
    end

    assert_redirected_to admin_user_path(assigns(:user))
  end

  def test_should_show_user
    get :show, :id => users(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => users(:one).id
    assert_response :success
  end

  def test_should_update_user
    put :update, :id => users(:one).id, :user => { }
    assert_redirected_to admin_user_path(assigns(:user))
  end

  def test_should_destroy_user
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:one).id
    end

    assert_redirected_to admin_users_path
  end
end
