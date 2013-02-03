class Person < ActiveRecord::Base

  has_and_belongs_to_many :presentations

  has_one :picture

  belongs_to :conference

  def full_email
    if self.name
      "#{self.name} <#{self.email}>"
    else
      self.email
    end
  end

  def given_name
    self.name.split(" ").first
  end

  def slotted?
    self.presentations.each do |p|
      if p.slot
        return true
      end
    end
    return false
  end

end
