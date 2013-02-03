require "utils.rb"

class Schedule < ActiveRecord::Base

  has_many :slots

  belongs_to :conference

  validates_uniqueness_of :conference_id

  after_create :create_key

  def create_schedule start_date, day_count, room_count, slot_length, scheme
    Presentation.find(:all).each do |presentation|
      presentation.slot = nil
      presentation.save!
    end
  
    (1..day_count).each do |i|
      day = start_date + i - 1
      if scheme == "akademy_2008"
        if i == 1
          specials = Array.new
          specials.push :time => "9:00", :duration => 15, :text => "Opening", :primitive => true
          specials.push :time => "9:15", :duration => 30, :text => "Keynote"
          specials.push :time => "9:45", :duration => 15, :text => "Coffee Break", :primitive => true
          specials.push :time => "11:00", :duration => 15, :text => "Break", :primitive => true
          specials.push :time => "12:00", :duration => 90, :text => "Lunch", :primitive => true
          specials.push :time => "13:30", :duration => 45, :text => "Keynote"
          specials.push :time => "15:30", :duration => 25, :text => "Waffle Break", :primitive => true
          specials.push :time => "16:30", :duration => 5, :text => "Break", :primitive => true
          specials.push :time => "17:00", :duration => 60, :text => "Plasma Frenzy"
          create_day "9:00", "18:00", day, room_count, slot_length, specials
        elsif i == day_count
          specials = Array.new
          specials.push :time => "10:15", :duration => 15, :text => "Coffee Break", :primitive => true
          specials.push :time => "12:00", :duration => 90, :text => "Lunch", :primitive => true
          specials.push :time => "13:30", :duration => 45, :text => "Keynote"
          specials.push :time => "15:30", :duration => 15, :text => "Coffee Break", :primitive => true
          specials.push :time => "16:45", :duration => 15, :text => "Break", :primitive => true
          specials.push :time => "17:00", :duration => 45, :text => "Akonadi Rumble"
          specials.push :time => "17:45", :duration => 15, :text => "Akademy Award Ceremony"
          specials.push :time => "18:00", :duration => 5, :text => "Closing", :primitive => true
          create_day "9:30", "18:05", day, room_count, slot_length, specials
        else
          create_day day, room_count, slot_length
        end
      elsif scheme == "akademy_2009"
        if i == 1
          specials = Array.new
          specials.push :time => "11:00", :duration => 30, :text => "Coffee Break", :primitive => true
          specials.push :time => "13:00", :duration => 120, :text => "Lunch", :primitive => true
          specials.push :time => "15:00", :duration => 45, :text => "Keynote"
          specials.push :time => "16:45", :duration => 30, :text => "Break", :primitive => true
          specials.push :time => "18:15", :duration => 15, :text => "Break", :primitive => true
          create_day "10:00", "19:00", day, room_count, slot_length, specials
        elsif i == day_count
          specials = Array.new
          specials.push :time => "11:00", :duration => 30, :text => "Coffee Break", :primitive => true
          specials.push :time => "13:00", :duration => 120, :text => "Lunch", :primitive => true
          specials.push :time => "15:00", :duration => 45, :text => "Keynote"
          specials.push :time => "16:45", :duration => 30, :text => "Break", :primitive => true
          specials.push :time => "18:45", :duration => 15, :text => "Akademy Award Ceremony"
          specials.push :time => "19:00", :duration => 5, :text => "Closing", :primitive => true
          create_day "10:00", "19:05", day, room_count, slot_length, specials
        else
          create_day day, room_count, slot_length
        end
      else
        raise "Unknown scheme '#{scheme}'"
      end
    end
  end

  def end
    start + ( day_count - 1 ).days
  end

  def days
    days = Array.new
    (1..day_count).each do |i|
      days.push start + i - 1
    end
    days
  end

  def slots_by_day day
    Slot.find_all_by_schedule_id_and_date self, day
  end

  def all_slots
    Slot.find_all_by_schedule_id self
  end

  def create_key
    self.key = Utils.make_random_string 16
  end

  private

  def create_common_slot day, time, duration, text, primitive = false
    if time.is_a? String
      time = Time.parse time
    end
    Slot.create :date => day, :start => time, :duration => duration,
      :room_id => 0, :text => text, :schedule_id => self.id, :primitive => primitive
  end

  def create_day start_time, end_time, day, room_count, slot_length, specials
    time = Time.parse start_time

    while time < Time.parse( end_time )
      special = specials.first
      if special and time >= Time.parse(special[:time])
        create_common_slot day, time, special[:duration],
          special[:text], special[:primitive]

        time += special[:duration].minutes
        
        specials.shift
      else
        (1..room_count).each do |track|
          Slot.create :date => day, :start => time, :duration => slot_length,
            :room_id => track, :text => "<em>Presentation</em>",
            :schedule_id => self.id
        end

        time += slot_length.minutes
      end
    end

  end

end
