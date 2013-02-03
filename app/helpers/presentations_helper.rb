module PresentationsHelper

  def show_rating rating
    if rating > 0
      "+" + rating.to_s
    else
      rating.to_s
    end
  end

  def author_links people, options = {}
    if !people or people.empty?
      return "<em>No author</em>".html_safe
    else
      author_links = Array.new
      people.each do |person|
        person_link = link_to person.name, :controller => "people",
            :action => "show", :id => person.id
        if options[:email] and person.email and !person.email.empty?
          person_link += " <#{person.email}>"
        end
        author_links.push person_link
      end
      return author_links.join( ", " ).html_safe
    end
  end

  def author_list people
    if !people or people.empty?
      "<em>No author</em>".html_safe
    else
      people.map do |person|
        person.name
      end.join( ", " ).html_safe
    end
  end

end
