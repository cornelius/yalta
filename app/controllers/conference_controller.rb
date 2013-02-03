class ConferenceController < ApplicationController

  def export_acceptance_notification
    presentations = Presentation.find :all
    accepted = Array.new
    rejected = Array.new
    presentations.each do |presentation|
      if presentation.slot
        accepted.push presentation
      else
        rejected.push presentation
      end
    end
    
    out = String.new
        
    accepted.each do |presentation|
      sender = current_user
      mail = Mailer.create_acceptance_notification presentation, sender
      out += create_kmail_script mail
    end
        
    rejected.each do |presentation|
      sender = current_user
      mail = Mailer.create_rejection_notification presentation, sender
      out += create_kmail_script mail
    end
    
    render :text => out, :content_type => "text/plain"
  end

  def export_web_pages
    export = ExportWeb.new

    export.create_pages
        
    render :text => "Export done"
  end

  private
  
  def create_kmail_script mail
    out = "dcop kmail KMailIface openComposer \\\n"
    out += "\"#{mail.to}\" \\\n"
    out += "\"#{mail.cc}\" \"\" \\\n"
    out += "\"#{mail.subject}\" \\\n"
    out += "\"#{mail.body}\" \\\n"
    out += "0\n\n"
  end

end
