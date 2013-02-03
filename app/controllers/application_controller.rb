require "dummy_login_system"

class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all

  include DummyLoginSystem

  before_filter :login_required

  helper_method :current_user
  helper_method :current_conference

  def current_conference
    current_user.current_conference
  end

end
