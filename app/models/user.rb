class User < ActiveRecord::Base

  attr_protected :admin

  validates_uniqueness_of :openid_url, :on => :create
  validates_presence_of :openid_url

  belongs_to :current_conference, :class_name => "Conference"
  
  def is_admin?
    self.admin
  end

  def is_invited?
    self.invited or self.admin
  end

  def name
    display_name
  end
  
  def full_email
    "#{display_name} <#{email_address}>"
  end

end
