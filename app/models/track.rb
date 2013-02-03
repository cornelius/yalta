class Track < ActiveRecord::Base

  has_many :presentations

  belongs_to :conference

  attr_accessible :title, :color_style
  
  def sorted_presentations
    self.presentations.sort do |a,b|
      b.rating <=> a.rating
    end
  end

end
