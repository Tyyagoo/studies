defmodule WordCount do
  @punctuation ["\n", ".", ",", "_", "!", "&", "@", "$", "%", "^", ":"]

  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase()
    |> String.graphemes()
    |> filter([])
    |> Enum.frequencies()
  end

  defp filter([head | tail], acc) when head in @punctuation, do: filter(tail, [" " | acc])
  defp filter([head | tail], acc), do: filter(tail, [head | acc])

  defp filter([], acc) do
    acc
    |> Enum.reverse()
    |> Enum.chunk_by(&(&1 == " "))
    |> Enum.map(&join/1)
    |> Enum.map(fn str ->
      lst = Regex.run(~r/'(\w+)'/, str) || []
      List.last(lst, str)
    end)
    |> Enum.filter(&(&1 != ""))
  end

  defp join(lst), do: join(lst, "")
  defp join([" " | tail], acc), do: join(tail, acc)
  defp join([head | tail], acc), do: join(tail, acc <> head)
  defp join([], acc), do: acc
end
