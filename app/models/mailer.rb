class Mailer < ActionMailer::Base

  def acceptance_notification presentation, sender
    speaker = presentation.people.first
    recipients speaker.full_email
    cc "akademy-talks-2008@kde.org"
    subject "Your presentation for Akademy 2008 has been accepted"
    from sender.full_email

    body :speaker => speaker, :presentation => presentation, :sender => sender
  end

  def rejection_notification presentation, sender
    speaker = presentation.people.first
    recipients speaker.full_email
    cc "akademy-talks-2008@kde.org"
    subject "Your presentation proposal for Akademy 2008"
    from sender.full_email

    body :speaker => speaker, :presentation => presentation, :sender => sender
  end

end
