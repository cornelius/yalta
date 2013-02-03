class Presentation < ActiveRecord::Base
 
  acts_as_taggable

  has_and_belongs_to_many :people

  has_many :comments

  belongs_to :conference
  belongs_to :track
  belongs_to :slot
  belongs_to :presentation_type

  def rating_by user
    ratings = Comment.find_all_by_user_id user, :conditions => {
      :rated => true, :presentation_id => self.id }
    if ratings.empty?
      return nil
    end
    rating = 0
    ratings.each do |r|
      rating += r.rating
    end
    rating
  end

  def average_rating
    ratings = Hash.new
    comments = Comment.find_all_by_presentation_id( self.id )
    comments.each do |comment|
      if ratings.has_key? comment.user_id
        rating = ratings.fetch comment.user_id
      else
        rating = 0
      end
      rating += comment.rating
      ratings.store comment.user_id, rating
    end
    sum = 0
    ratings.each do |user,rating|
      sum += rating
    end
    sprintf "%0.1f", sum.to_f / ratings.keys.size
  end

  def speaker
    people.first
  end
  
end
