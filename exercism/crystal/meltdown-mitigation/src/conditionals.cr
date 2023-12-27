class Reactor
  def self.criticality_balanced?(temperature, neutrons_emitted)
    (temperature < 800) && (neutrons_emitted > 500) && (temperature * neutrons_emitted < 500000)
  end

  def self.reactor_efficiency(voltage, current, theoretical_max_power)
    generated_power = voltage * current
    efficiency = generated_power / theoretical_max_power
    if    efficiency >= 0.8 "green"
    elsif efficiency >= 0.6 "orange"
    elsif efficiency >= 0.3 "red"
    else "black" end
  end

  def self.fail_safe(temperature, neutrons_produced_per_second, threshold)
  status = (temperature * neutrons_produced_per_second) / threshold
    if    status <= 0.9 "LOW"
    elsif status <= 1.1 "NORMAL"
    else "DANGER" end
  end
end
