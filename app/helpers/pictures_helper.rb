module PicturesHelper

  def full_picture_tag person
    picture_tag person, "full"
  end

  def thumb_picture_tag person
    picture_tag person, "thumb"
  end

  def mini_picture_tag person
    picture_tag person, "mini"
  end

  private

  def picture_tag person, size
    if person.picture
      image_tag url_for( :controller => "pictures", :action => size,
        :id => person.picture )
    else
      ""
    end
  end

end
