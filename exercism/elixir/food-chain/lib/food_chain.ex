defmodule FoodChain do
  # food ~ narrator ~ action
  @data [
    {"fly", "", nil},
    {"spider", "It wriggled and jiggled and tickled inside her.",
     "wriggled and jiggled and tickled inside her"},
    {"bird", "How absurd to swallow a bird!", nil},
    {"cat", "Imagine that, to swallow a cat!", nil},
    {"dog", "What a hog, to swallow a dog!", nil},
    {"goat", "Just opened her throat and swallowed a goat!", nil},
    {"cow", "I don't know how she swallowed a cow!", nil},
    {"horse", "She's dead, of course!", nil}
  ]
  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    start..stop
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end

  defp verse(8) do
    {food, narrator, nil} = Enum.at(@data, 7)

    """
    #{swallow(food)}
    #{narrator}
    """
  end

  defp verse(n) do
    {food, narrator, _} = Enum.at(@data, n - 1)

    reasons =
      n..2//-1
      |> Enum.map(&swallow_reason/1)
      |> Enum.join("\n")

    [
      swallow(food),
      narrator,
      reasons,
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ]
    |> Enum.filter(&(&1 != ""))
    |> Enum.join("\n")
  end

  defp swallow(food), do: "I know an old lady who swallowed a #{food}."

  defp swallow_reason(n) do
    {food, _, _} = Enum.at(@data, n - 1)
    {reason, _, maybe_action} = Enum.at(@data, n - 2)
    action = if maybe_action != nil, do: " that #{maybe_action}", else: ""
    "She swallowed the #{food} to catch the #{reason}#{action}."
  end
end
