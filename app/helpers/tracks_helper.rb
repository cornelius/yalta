module TracksHelper

  def track_class track
    if track
      "track_#{track.color_style}"
    else
      ""
    end
  end

end
