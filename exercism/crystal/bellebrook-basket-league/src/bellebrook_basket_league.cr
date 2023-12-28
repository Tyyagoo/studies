module TicketingReservation
  extend self

  def tickets_available
    @tickets_available
  end

  def stadium
    @stadium
  end

  def order_ticket?
    if @tickets_available < 100
      return false
    end
    @tickets_available -= 1
    true
  end

  def order_message(name)
    if order_ticket?
      "#{name}, your purchase was successful, your ticket number is ##{tickets_available + 1}, and the game is played at the #{stadium} stadium."
    else
      "#{name}, your purchase was unsuccessful, there are not enough tickets available."
    end
  end
end

class TicketSystem
  include TicketingReservation
  def initialize(@tickets_available : Int32, @stadium : String) end
end
