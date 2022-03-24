defmodule Exercises.Chapter2.Second do
  @moduledoc """
  Bob has traveled 200 km in four hours. Using variables, print a message
  showing his travel distance, time, and average velocity.
  """

  def show(km, hours) do
    info(km, hours)
    |> IO.puts()
  end

  @doc """
  Returns information about Bob's travel.
  
  Example:
    iex>Exercises.Chapter2.Second.info(200, 4)
    "Bob has traveled 200km during 4 hours, and his average velocity has been 50.0km/h."
  """
  @spec info(km :: integer(), hours :: integer()) :: String.t()
  def info(km, hours) do
    "Bob has traveled #{km}km during #{hours} hours, and his average velocity has been #{km / hours}km/h."
  end
end
