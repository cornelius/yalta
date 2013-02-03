class Slot < ActiveRecord::Base

  belongs_to :schedule

  has_one :presentation

  def end
    start + duration.minutes
  end

  def track
    if self.presentation
      self.presentation.track
    else
      nil
    end
  end

  def available?
    !primitive and !presentation
  end

end
