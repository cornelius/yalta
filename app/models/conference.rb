class Conference < ActiveRecord::Base

  has_many :users
  has_many :presentations
  has_many :people
  has_many :invitations

  has_one :schedule

  attr_accessible :name

  def to_s
    self.name
  end

end
