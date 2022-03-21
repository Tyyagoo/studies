defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()

  def verse(n) do
    "#{n |> bottle() |> String.capitalize()} on the wall, #{bottle(n)}.\n#{action(n)}, #{bottle(n - 1)} on the wall.\n"
  end

  defp bottle(n) when n > 1, do: "#{n} bottles of beer"
  defp bottle(1), do: "1 bottle of beer"
  defp bottle(0), do: "no more bottles of beer"
  defp bottle(_), do: bottle(99)

  defp action(n) when n > 1, do: "Take one down and pass it around"
  defp action(1), do: "Take it down and pass it around"
  defp action(0), do: "Go to the store and buy some more"

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    range
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end
end
