class AccountController < ApplicationController

  skip_before_filter :login_required

  def invitation
  end
  
  def accept_invitation
    invitation = Invitation.find_by_token params[:token]
    if !invitation
      if params[:token].blank?
        flash[:warning] = "Please enter your invitation code"
      else
        flash[:error] = "The invitation code is not valid."
      end
      redirect_to :action => "invitation"
    else
      session[:invitation_code] = params[:token]
      invitation.accepted_at = DateTime.now
      invitation.save!
      flash[:notice] = "Your invitation has been accepted"
      redirect_to :action => "login"
    end
  end
  
  def login
  end

  def callback
    auth_hash = request.env['omniauth.auth']

    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    email = auth_hash[:info][:email]

    user = User.find_by_openid_url uid

    if user.nil?
      user = User.new(:openid_url => uid)

      # The first user becomes admin user
      if User.count == 0
        user.invited = true
        user.admin = true
      end
    end

    user.display_name = name unless name.blank?
    user.email_address = email unless email.blank?

    user.last_login = DateTime.now

    user.save!

    session[:user_id] = user.id

    if !user.is_invited?
      if session[:invitation_code]
        invitation = Invitation.find_by_token session[:invitation_code]
        if !invitation
          flash[:error] = "Invalid invitation code"
          clear_login
          redirect_to :action => "login"
          return
        end
        invitation.user_id = user.id
        invitation.save!

        user.invited = true
        user.current_conference = invitation.conference
        session[:invitation_code] = nil
      else
        redirect_to :action => "sorry_invitation"
        return
      end
    end

    flash[:notice] = "Welcome #{name}"
    
    redirect_back_or_default "/"
  end

  def logout
    clear_login
    redirect_to "/"
  end
    
  def welcome
  end

  def sorry_admin
  end

  def sorry_invitation
    flash[:error] = "Sorry, only invited users have access to the site."
    clear_login
    redirect_to :action => :login
  end

  def new_user
    current_user.attributes = params[:user]
  end

  def update_new_user
    if current_user.update_attributes(params[:user])
      redirect_back_or_default "/"
      return
    end
    render :template => 'account/new_user'
  end

  private

  def clear_login
    session[:user_id] = nil
    @current_user = nil
  end
  
end
