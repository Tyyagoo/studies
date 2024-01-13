defmodule BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """

  @numbers %{
    10 => "ten",
    9 => "nine",
    8 => "eight",
    7 => "seven",
    6 => "six",
    5 => "five",
    4 => "four",
    3 => "three",
    2 => "two",
    1 => "one",
    0 => "no"
  }

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down) do
    0..(take_down - 1)
    |> Stream.map(&verse(start_bottle - &1))
    |> Enum.join("\n")
    |> String.trim
  end

  defp verse(number) do
    n = Map.get(@numbers, number) |> String.capitalize
    b = if number == 1, do: "bottle", else: "bottles"
    """
    #{n} green #{b} hanging on the wall,
    #{n} green #{b} hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be #{Map.get(@numbers, number - 1)} green bottle#{if number == 2, do: "", else: "s"} hanging on the wall.
    """
  end
end
