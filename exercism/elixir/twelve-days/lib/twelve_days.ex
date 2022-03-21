defmodule TwelveDays do
  @count %{
    1 => "first",
    2 => "second",
    3 => "third",
    4 => "fourth",
    5 => "fifth",
    6 => "sixth",
    7 => "seventh",
    8 => "eighth",
    9 => "ninth",
    10 => "tenth",
    11 => "eleventh",
    12 => "twelfth"
  }

  @gifts [
    "a Partridge in a Pear Tree",
    "two Turtle Doves",
    "three French Hens",
    "four Calling Birds",
    "five Gold Rings",
    "six Geese-a-Laying",
    "seven Swans-a-Swimming",
    "eight Maids-a-Milking",
    "nine Ladies Dancing",
    "ten Lords-a-Leaping",
    "eleven Pipers Piping",
    "twelve Drummers Drumming"
  ]

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    opening(number) <> gift(number)
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    starting_verse..ending_verse
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    verses(1, 12)
  end

  defp opening(day) do
    "On the " <> Map.get(@count, day) <> " day of Christmas my true love gave to me: "
  end

  defp gift(0, _, acc), do: acc |> join()
  defp gift(day, [head | tail], acc), do: gift(day - 1, tail, [head | acc])

  defp gift(day) do
    gift(day, @gifts, [])
  end

  defp join([head | tail]), do: do_join(tail, "#{head}")

  defp do_join([], acc), do: "#{acc}."
  defp do_join([head | []], acc), do: "#{acc}, and #{head}."
  defp do_join([head | tail], acc), do: do_join(tail, "#{acc}, #{head}")
end
