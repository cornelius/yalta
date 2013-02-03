require File.dirname(__FILE__) + '/../test_helper'

class ConferenceControllerTest < ActionController::TestCase

  def test_overview
    login users(:admin)
  
    get :index
    assert_response :success
  end

end
