defmodule Exercises.Chapter2.Fourth do
  @moduledoc """
  Create a module called MatchstickFactory and a function called boxes/1.
  The factory has three types of boxes: the big ones hold fifty matchsticks,
  the medium ones hold twenty, and the small ones hold five.
  The boxes can’t have fewer matchstick that they can hold; they
  must be full. The returning map should contain the remaining matchsticks.
  
  """

  @big 50
  @medium 20
  @small 5

  @doc """
  Calculate the number of boxes necessary to accommodate some matchsticks.
  It returns a map with the number of boxes necessary for each type of box.
  
  Examples:
    iex> alias Exercises.Chapter2.Fourth
    Exercises.Chapter2.Fourth
    iex> Fourth.boxes(98)
    %{big: 1, medium: 2, remaining_matchsticks: 3, small: 1}
    iex> Fourth.boxes(39)
    %{big: 0, medium: 1, remaining_matchsticks: 4, small: 3}
  """
  def boxes(sticks) do
    big = div(sticks, @big)
    remaining = rem(sticks, @big)

    medium = div(remaining, @medium)
    remaining = rem(remaining, @medium)

    small = div(remaining, @small)
    remaining = rem(remaining, @small)

    %{big: big, medium: medium, small: small, remaining_matchsticks: remaining}
  end
end
