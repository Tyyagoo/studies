defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    [{3, "Pling"}, {5, "Plang"}, {7, "Plong"}]
    |> Enum.reduce("", fn {factor, out}, acc -> append_if(number, factor, acc, out) end)
    |> default_to("#{number}")
  end

  defp append_if(number, factor, acc, _) when rem(number, factor) != 0, do: acc
  defp append_if(_, _, acc, appendable), do: acc <> appendable

  defp default_to("", default), do: default
  defp default_to(normal, _), do: normal
end
