defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Task.async_stream(
      fn str ->
        str
        |> String.downcase()
        |> String.graphemes()
        |> Enum.filter(fn g -> Regex.match?(~r/[[:alpha:]]/, g) end)
        |> Enum.frequencies()
      end,
      max_concurrency: workers,
      ordered: false
    )
    |> Enum.reduce(%{}, fn {:ok, map}, acc ->
      Map.merge(acc, map, fn _, x, y -> x + y end)
    end)
  end
end
