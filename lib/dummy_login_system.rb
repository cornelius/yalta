module DummyLoginSystem
  
  protected
  
  # overwrite this if you want to restrict access to only a few actions
  # or if you want to check if the user has the correct rights  
  # example:
  #
  #  # only allow nonbobs
  #  def authorize?(user)
  #    user.login != "bob"
  #  end
  def authorize?(user)
    user.admin? or user.invited?
  end
  
  # overwrite this method if you only want to protect certain actions of the controller
  # example:
  # 
  #  # don't protect the login and the about method
  #  def protect?(action)
  #    if ['action', 'about'].include?(action)
  #       return false
  #    else
  #       return true
  #    end
  #  end
  def protect?(action)
    true
  end
   
  # Return current user. Don't use @current_user directly.
  #
  # Returns a user <tt>@current_user</tt> if <tt>session[:user_id]</tt> can be
  # found, <tt>nil</tt> otherwise.
  #
  def current_user
    return @current_user if @current_user
    
    user_id = session[:user_id]
    if !user_id
      @current_user = nil
    else
      begin
        @current_user = User.find user_id
      rescue ActiveRecord::RecordNotFound
        @current_user = nil
      end
    end
  end

  # login_required filter. add 
  #
  #   before_filter :login_required
  #
  # if the controller should be under any rights management. 
  # for finer access control you can overwrite
  #   
  #   def authorize?(user)
  # 
  def login_required
    return true unless protect? action_name
    return true if current_user and authorize? @current_user

    # store current location so that we can 
    # come back after the user logged in
    store_location

    if current_user and !current_user.is_invited?
      redirect_to :controller => "/account", :action => "sorry_invitation"
      return false
    end
  
    # call overwriteable reaction to unauthorized access
    access_denied
    return false 
  end

  # checks, whether the current user <tt>@current_user</tt> is an admin or not.
  #
  # Redirects to an error page if user is not an admin, does nothing otherwise.
  #
  # Note: <tt>@current_user</tt> is set in the setup_user method, which gets called
  # before this method.
  #
  # This method is being used as a <i>before_filter</i> for actions that need admin
  # privileges.
  def admin_required
    if !login_required
      return false
    end
  
    if !@current_user or !@current_user.is_admin?
      redirect_to :controller => "/account", :action => "sorry_admin"
      return false
    end
  end

  # overwrite if you want to have special behavior in case the user is not authorized
  # to access the current operation. 
  # the default action is to redirect to the login screen
  # example use :
  # a popup window might just close itself for instance
  def access_denied
    redirect_to :controller=>"/account", :action =>"login"
  end  
  
  # store current uri in  the session.
  # we can return to this location by calling return_location
  def store_location
    session[:return_to] = request.fullpath
  end

  # move to the last store_location call or to the passed default one
  def redirect_back_or_default(default)
    if session[:return_to].nil?
      redirect_to default
    else
      redirect_to session[:return_to]
      session[:return_to] = nil
    end
  end

end
