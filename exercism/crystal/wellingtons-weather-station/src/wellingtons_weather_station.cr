class Temperature
  def to_kelvin(celsius)
    celsius + 273.15
  end

  def round(celsius)
    celsius.round(1)
  end

  def to_fahrenheit(celsius)
    (celsius * 1.8 + 32).ceil
  end

  def number_missing_sensors(number_of_sensors)
    rem = number_of_sensors % 4
    rem == 0 ? rem : (4 - rem)
  end
end
