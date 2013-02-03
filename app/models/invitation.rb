class Invitation < ActiveRecord::Base

  belongs_to :user
  belongs_to :conference

  after_create :set_expire_date

  def set_expire_date
    self.expires_at = DateTime.now + 7.days
    self.token = Utils.make_random_string 16
  end

  def full_email
    if name
      "#{name} <#{email}>"
    else
      email
    end
  end

end
