module SubmissionHelper
  include TagsHelper

  def tag_list presentation
    if presentation.tag_list.empty?
      return "<em>no tags</em>"
    end
    tags = Array.new
    presentation.tag_list.each do |tag|
      tags.push link_to( tag, :controller => "submission", :action => "tag",
        :id => tag )
    end
    tags.join ", "
  end

end
