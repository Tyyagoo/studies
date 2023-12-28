class Clock
  getter hour : Int32
  getter minute : Int32
  def initialize(hour : Int32 = 0, minute : Int32 = 0)
    @minute = minute % 60
    extra_hours = minute // 60
    @hour = (hour + extra_hours) % 24
  end

  def to_s
    "#{@hour.to_s.rjust(2, '0')}:#{@minute.to_s.rjust(2, '0')}"
  end

  def + (other : Clock)
    Clock.new(hour: @hour + other.hour, minute: @minute + other.minute)
  end

  def - (other : Clock)
    Clock.new(hour: @hour - other.hour, minute: @minute - other.minute)
  end

  def == (other : Clock)
    @hour == other.hour && @minute == other.minute
  end
end
