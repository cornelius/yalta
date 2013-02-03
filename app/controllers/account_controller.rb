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
    if request.get?
      return
    end

    openid_url = params[:openid_url]

    return if fake_open_id_login openid_url
    
    begin
      oidreq = consumer.begin(params[:openid_url])
    rescue OpenID::OpenIDError => e
      flash[:error] = "Discovery failed for #{params[:openid_url]}: #{e}"
      render
      return
    end

    ask_for_open_id_fields(oidreq)

    return_to = url_for :action => 'complete', :only_path => false
    realm = url_for :controller => "/", :only_path => false
    
    if oidreq.send_redirect?(realm, return_to, params[:immediate])
      redirect_to oidreq.redirect_url(realm, return_to, params[:immediate])
    else
      @form_text = oidreq.form_markup(realm, return_to, params[:immediate], {'id' => 'openid_form'})
    end
  end

  def complete
    # FIXME - url_for some action is not necessarily the current URL.
    current_url = url_for(:action => 'complete', :only_path => false)
    parameters = params.reject{|k,v|request.path_parameters[k]}
    oidresp = consumer.complete(parameters, current_url)
    case oidresp.status
    when OpenID::Consumer::FAILURE
      if oidresp.display_identifier
        flash[:error] = ("Verification of #{oidresp.display_identifier}"\
                         " failed: #{oidresp.message}")
      else
        flash[:error] = "Verification failed: #{oidresp.message}"
      end
    when OpenID::Consumer::SUCCESS
    
      @user = create_user_and_login(oidresp)
      @user.last_login = DateTime.now

      if !@user.is_invited?
        if session[:invitation_code]
          invitation = Invitation.find_by_token session[:invitation_code]
          if !invitation
            flash[:error] = "Invalid invitation code"
            clear_login
            redirect_to :action => "login"
            return
          end
          invitation.user_id = @user.id
          invitation.save!

          @user.invited = true
          @user.current_conference = invitation.conference
          session[:invitation_code] = nil
        else
          redirect_to :action => "sorry_invitation"
          return
        end
      end

      @user.save_without_validation!

      user_data = open_id_fields(oidresp)

      if !@user.has_required_attributes?
        redirect_to :action => "new_user", :user => user_data
        return
      else
        redirect_back_or_default "/"
        return
      end

    when OpenID::Consumer::SETUP_NEEDED
      flash[:alert] = "Immediate request failed - Setup Needed"
    when OpenID::Consumer::CANCEL
      flash[:alert] = "OpenID transaction cancelled."
    else
    end
    redirect_to :action => 'login'
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

  def consumer
    if @consumer.nil?
      dir = Pathname.new(RAILS_ROOT).join('db').join('cstore')
      store = OpenID::Store::Filesystem.new(dir)
      @consumer = OpenID::Consumer.new(session, store)
    end
    return @consumer
  end

  def fake_open_id_login openid_url
    if Prefs.fake_openid
      session[:user_id] = User.find_by_openid_url "http://#{openid_url}/"
      if session[:user_id].nil?
        flash[:notice] = "OpenId URL not found in system."
      else
        redirect_back_or_default "/"
      end
      true
    else
      false
    end
  end
  
  def ask_for_open_id_fields(oidreq)
    sregreq = OpenID::SReg::Request.new
    # optional fields
    sregreq.request_fields(['email','fullname'], false)
    oidreq.add_extension(sregreq)
    oidreq.return_to_args['did_sreg'] = 'y'
  end
  
  def create_user_and_login(oidresp)
    user = User.find_by_openid_url oidresp.identity_url

    # create user object if one does not exist
    if user.nil?
      user = User.new(:openid_url => oidresp.identity_url)
      user.save_without_validation!
    end

    # storing both the openid_url and user id in the session for for quick
    # access to both bits of information.  Change as needed.
    session[:user_id] = user.id
    return user
  end
  
  def open_id_fields(oidresp)
    user_data = {}
    if params[:did_sreg]
      sreg_resp = OpenID::SReg::Response.from_success_response(oidresp)
      user_data = { :display_name => sreg_resp.data[ "fullname" ],
            :email_address => sreg_resp.data[ "email" ] } 
    end
    user_data
  end

  def clear_login
    session[:user_id] = nil
    @current_user = nil
  end
  
end
