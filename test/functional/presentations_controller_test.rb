require File.dirname(__FILE__) + '/../test_helper'

class PresentationsControllerTest < Test::Unit::TestCase

  fixtures :users

  def setup
    @controller = PresentationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login users(:invited)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:presentations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_presentation
    assert_difference('Presentation.count') do
      post :create, :presentation => { }
    end

    assert_redirected_to presentation_path(assigns(:presentation))
  end

  def test_should_show_presentation
    get :show, :id => presentations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => presentations(:one).id
    assert_response :success
  end

  def test_should_update_presentation
    put :update, :id => presentations(:one).id, :presentation => { }
    assert_redirected_to presentation_path(assigns(:presentation))
  end

  def test_should_destroy_presentation
    assert_difference('Presentation.count', -1) do
      delete :destroy, :id => presentations(:one).id
    end

    assert_redirected_to presentations_path
  end
end
