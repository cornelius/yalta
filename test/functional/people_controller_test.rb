require File.dirname(__FILE__) + '/../test_helper'

class PeopleControllerTest < ActionController::TestCase

  def setup
    @controller = PeopleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login users(:invited)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_person
    assert_difference('Person.count') do
      post :create, :person => { }
    end

    assert_redirected_to person_path(assigns(:person))
  end

  def test_should_show_person
    get :show, :id => people(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => people(:one).id
    assert_response :success
  end

  def test_should_update_person
    put :update, :id => people(:one).id, :person => { }
    assert_redirected_to person_path(assigns(:person))
  end

  def test_should_destroy_person
    assert_difference('Person.count', -1) do
      delete :destroy, :id => people(:one).id
    end

    assert_redirected_to people_path
  end

  def test_add_author
    presentation = Presentation.find :first
    get :add_author, :id => presentation.id
    assert_response :success
  end

  def test_save_add_author
    presentation = Presentation.find :first
    assert_difference('Presentation.find(:first).people.size', +1) do
      assert_difference('Person.count') do
        post :save_add_author, :person => { :name => "Hans Wurst" },
          :presentation => presentation.id
      end
    end
    assert_redirected_to presentation_path(presentation)
  end

  def test_save_add_existing_author
    presentation = Presentation.find :first
    person = people(:two)
    assert_difference('Presentation.find(:first).people.size', +1) do
      post :save_add_existing_author, :presentation => presentation.id,
        :person => person.id
    end
    assert_redirected_to presentation_path(presentation)
  end
  
end
