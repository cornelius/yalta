class Admin::InvitationsController < Admin::BaseController

  before_filter :admin_required

  include Admin::InvitationsHelper
  helper "admin/invitations"

  def index
    @invitations = Invitation.find :all, :order => "id DESC"
  end
  
  def add
    if params[:full_email] =~ /^(.*) \<(.*)\>$/
      name = $1
      email = $2
    else
      name = nil
      email = params[:full_email]
    end
    
    invitation = Invitation.create :name => name, :email => email,
      :conference => current_conference
    invitation.save!
    
    flash[:notice] = "Invitation for #{ERB::Util.h invitation.full_email} created."
    redirect_to :back
  end

  def show
    @invitation = Invitation.find params[:id]
  end

  def show_email
    @invitation = Invitation.find params[:id]

    @mail = InvitationMailer.create_invitation @invitation,
      invitation_url( @invitation ),
      invitation_url_base
  end

  def send_email
    invitation = Invitation.find params[:id]

    InvitationMailer.deliver_invitation invitation, invitation_url( invitation ),
      invitation_url_base

    invitation.sent_at = Time.now
    invitation.save!
    
    flash[:notice] = "Invitation sent to #{ERB::Util.h invitation.full_email}."
    redirect_to :back
  end

end
