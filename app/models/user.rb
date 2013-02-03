class User < ActiveRecord::Base

  attr_protected :admin

  validates_uniqueness_of :display_name
  validates_format_of :display_name, :with => /^[A-Z0-9_ ()]*$/i,
    :message => 'may only contain letters, numbers, underscores and round brackets'
  validates_length_of :display_name, :within => 3..60
  validates_uniqueness_of :openid_url, :on => :create
  validates_presence_of :openid_url
  validates_format_of :email_address, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix

  belongs_to :current_conference, :class_name => "Conference"
  
  def has_required_attributes?
    if !display_name or display_name.empty?
      false
    else
      true
    end
  end
  
  def is_admin?
    self.admin
  end

  def is_invited?
    self.invited or self.admin
  end

  def name
    # Do not substitute this string, because of name collisions
    # and different open id providers use different parts of the URL for the username
    name = self.openid_url

    #use a display name if it exists
    name = self.display_name if self.display_name and self.display_name.length > 0
    name
  end

  def full_email
    "#{display_name} <#{email_address}>"
  end
 
  def ambiguous_url
    openid_url =~ /^(http.?):\/\/(.*)/

    protocol = $1
    rest = $2
    
    if protocol == "http"
      ambiguous_url = "https://#{rest}"
    else
      ambiguous_url = "http://#{rest}"
    end

    ambiguous_user = User.find_by_openid_url ambiguous_url
    if ambiguous_user
      ambiguous_url
    else
      nil
    end
  end
  
  protected

  def validate
    errors.add :display_name, 'may not have 2 spaces in a row' if display_name =~ /  /
    errors.add :display_name, 'may not end with a space' if display_name =~ / $/
    errors.add :display_name, 'may not begin with a space' if display_name =~ /^ /
  end
  
end
