class SlotsController < ApplicationController

  def index
    @slots = Slot.find_all_by_schedule_id current_conference.schedule
  end
  
end
