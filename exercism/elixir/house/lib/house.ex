defmodule House do
  @verbs [
    "lay in",
    "ate",
    "killed",
    "worried",
    "tossed",
    "milked",
    "kissed",
    "married",
    "woke",
    "kept",
    "belonged to"
  ]

  @actors [
    "malt",
    "rat",
    "cat",
    "dog",
    "cow with the crumpled horn",
    "maiden all forlorn",
    "man all tattered and torn",
    "priest all shaven and shorn",
    "rooster that crowed in the morn",
    "farmer sowing his corn",
    "horse and the hound and the horn"
  ]

  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    all_phrases = phrases(1, stop, @actors, @verbs, []) |> Enum.reverse()

    start..stop
    |> Stream.map(fn verse_number ->
      verse =
        all_phrases
        |> Enum.slice(0, verse_number)
        |> Enum.reverse()
        |> Enum.join(" ")

      "This is #{verse}.\n"
    end)
    |> Enum.join()
  end

  defp phrases(1, stop, actors, verbs, _) do
    phrases(2, stop, actors, verbs, ["the house that Jack built"])
  end

  defp phrases(start, stop, [actor | actors], [verb | verbs], acc) when start <= stop do
    phrases(start + 1, stop, actors, verbs, ["the #{actor} that #{verb}" | acc])
  end

  defp phrases(_, _, _, _, acc), do: acc
end
