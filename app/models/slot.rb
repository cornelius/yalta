class Slot < ActiveRecord::Base

  belongs_to :schedule

  has_one :presentation

  attr_accessible :date, :start, :duration, :room_id, :text, :schedule_id,
    :primitive

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
