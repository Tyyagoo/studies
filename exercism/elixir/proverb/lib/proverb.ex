defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite([h | _] = strings) do
    strings
    |> do_recite(h, [])
    |> Enum.reduce("", &<>/2)
  end

  defp do_recite([f, s | t], first, acc), do: do_recite([s | t], first, [verse(f, s) | acc])
  defp do_recite(_, first, acc), do: [verse(first) | acc]

  defp verse(uniq), do: "And all for the want of a #{uniq}.\n"
  defp verse(first, second), do: "For want of a #{first} the #{second} was lost.\n"
end
