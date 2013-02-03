require File.dirname(__FILE__) + '/../../test_helper'

class Admin::PresentationTypesControllerTest < Test::Unit::TestCase

  def setup
    @controller = Admin::PresentationTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login users(:admin)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:presentation_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_presentation_type
    assert_difference('PresentationType.count') do
      post :create, :presentation_type => { }
    end

    assert_redirected_to admin_presentation_type_path(assigns(:presentation_type))
  end

  def test_should_show_presentation_type
    get :show, :id => presentation_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => presentation_types(:one).id
    assert_response :success
  end

  def test_should_update_presentation_type
    put :update, :id => presentation_types(:one).id, :presentation_type => { }
    assert_redirected_to admin_presentation_type_path(assigns(:presentation_type))
  end

  def test_should_destroy_presentation_type
    assert_difference('PresentationType.count', -1) do
      delete :destroy, :id => presentation_types(:one).id
    end

    assert_redirected_to admin_presentation_types_path
  end
end
