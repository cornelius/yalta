module Admin::InvitationsHelper

  def invitation_url invitation
    url_for :controller => "/account", :action => "invitation",
      :token => invitation.token, :only_path => false
  end

  def invitation_url_base
    url_for :controller => "/account", :action => "invitation",
      :only_path => false
  end

end
