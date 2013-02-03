class InvitationMailer < ActionMailer::Base

  def invitation invitation, url, url_base
    recipients invitation.full_email
    subject "Invitation to Akademy Conference Planning System"
    from "schumacher@kde.org"

    body :invitation => invitation,
      :invitation_url => url,
      :invitation_url_base => url_base
  end

end
