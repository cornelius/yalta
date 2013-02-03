module SlotsHelper

  def compact_time time
    "#{time.hour}:#{sprintf "%02d", time.min }"
  end

  def slot_time slot
    compact_time( slot.start ) + " - " + compact_time( slot.end )
  end

  def slot_date_time slot
    out = slot.date.strftime("%a, %d %b %Y") + ", " + slot_time( slot )
    if slot.room_id and slot.room_id != 0 
      out += ", Room #{slot.room_id}"
    end
    out
  end

  def slot_title slot
    if slot.presentation
      slot.presentation.title
    else
      slot.text
    end
  end

end
