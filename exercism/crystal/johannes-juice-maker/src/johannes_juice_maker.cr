class JuiceMaker
  def initialize(@fluid : Int32)
    @running = false
  end

  def start
    @running = true
  end

  def running?
    @running
  end

  def add_fluid(amount)
    @fluid += amount
  end

  def stop(running_time)
    @fluid -= running_time * 5
    @running = false
  end

  def self.debug_light_on?
    true
  end
end
