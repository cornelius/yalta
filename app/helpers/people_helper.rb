module PeopleHelper

  def presentation_links presentations
    if !presentations or presentations.empty?
      return "<em>No presentations</em>"
    else
      links = Array.new
      presentations.each do |p|
        link = link_to p.title, :controller => "presentations",
            :action => "show", :id => p.id
        links.push link
      end
      return links.join( ", " )
    end
  end

end
