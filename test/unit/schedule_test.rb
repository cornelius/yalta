require File.dirname(__FILE__) + '/../test_helper'

class ScheduleTest < ActiveSupport::TestCase

  def test_create_schedule
    schedule = Schedule.new
    assert_difference 'Slot.count', +51 do
      schedule.create_schedule Time.now, 2, 2, 30, "akademy_2008"
    end
    assert_difference 'Slot.count', +51 do
      schedule.create_schedule Time.now, 2, 2, 30, "akademy_2009"
    end
    assert_raise RuntimeError do
      schedule.create_schedule Time.now, 2, 2, 30, "invalid_scheme"
    end
  end

end
