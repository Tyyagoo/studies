defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(s, size) when size < 1 or length(s) < size, do: []
  def slices(s, size), do: s |> String.graphemes() |> iterate(size, [])

  defp iterate([_ | t] = g, size, acc), do: iterate(t, size, [substring(g, size, "") | acc])
  defp iterate([], _, acc), do: acc |> Enum.filter(&(&1 != nil)) |> Enum.reverse()

  defp substring([h | t], size, acc) when size > 0, do: substring(t, size - 1, acc <> h)
  defp substring(_, 0, acc), do: acc
  defp substring([], _, _), do: nil
end
