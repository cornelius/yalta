require File.dirname(__FILE__) + '/../test_helper'

class SubmissionControllerTest < ActionController::TestCase

  def setup
    @controller = SubmissionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login users(:invited)
  end

  def test_assign_type
    get :assign_type, :id => presentations(:one)
    assert_response :success
  end

  def test_save_assign_type
    post :save_assign_type, :id => presentations(:one),
      :type => presentation_types(:one).id
    assert_redirected_to :controller => :presentations, :action => :show,
      :id => presentations(:one)
    presentation = Presentation.find presentations(:one).id
    assert_equal presentation_types(:one), presentation.presentation_type
  end

end
