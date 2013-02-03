class Track < ActiveRecord::Base

  has_many :presentations

  belongs_to :conference

  def sorted_presentations
    self.presentations.sort do |a,b|
      b.rating <=> a.rating
    end
  end

end
