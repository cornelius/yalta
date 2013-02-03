# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def text2html txt
    html = txt.gsub /\r\n\r\n/, "</p><p>"
    "<p>" + html + "</p>"
  end

end
