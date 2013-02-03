class ScheduleController < ApplicationController

  def index
    @schedule = current_conference.schedule
  end

  def new
    @schemes = [ "akademy_2009", "akademy_2008" ]
  end

  def create
    schedule = Schedule.new
    schedule.day_count = params[:day_count]
    schedule.room_count = params[:room_count]
    schedule.slot_length = params[:slot_length]
    schedule.conference = current_conference

    start_date = Date.new(
      params[:conference]["start(1i)"].to_i,
      params[:conference]["start(2i)"].to_i,
      params[:conference]["start(3i)"].to_i )
    schedule.start = start_date
    
    schedule.save!

    schedule.create_schedule start_date, params[:day_count].to_i,
      params[:room_count].to_i, params[:slot_length].to_i, params[:scheme]


    redirect_to :action => "all"
  end

  def delete
    current_conference.schedule.destroy
    redirect_to :action => :index
  end

  def all
    @schedule = current_conference.schedule
    @slot_content = "show_slot_content"
  end

  def day
    @day = params[:date]
    @schedule = current_conference.schedule
    @slot_content = "show_slot_content"
  end

  def export
    @schedule = current_conference.schedule
    @slot_content = "show_slot_content"
    render :layout => false
  end

  def slots_as_csv
    csv = ""
    current_conference.schedule.all_slots.each do |slot|
      if slot.presentation
        csv += slot.presentation.speaker.full_email
        csv += ","
        csv += slot.presentation.title
        csv += "\n"
      end
    end
    render :text => csv, :content_type => "text/plain"
  end

  private
  
end
