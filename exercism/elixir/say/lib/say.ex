defmodule Say do
  @scales ~w(thousand million billion)
  @simple_numbers ~w(zero one two three four five six seven eight nine)
  @composite_numbers %{
    1 => ~w(ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen),
    2 => "twenty",
    3 => "thirty",
    4 => "forty",
    5 => "fifty",
    6 => "sixty",
    7 => "seventy",
    8 => "eighty",
    9 => "ninety"
  }

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(n) when n < 0 or n >= 1_000_000_000_000 do
    {:error, "number is out of range"}
  end

  def in_english(number) do
    number
    |> Integer.digits()
    |> Enum.reverse()
    |> Enum.chunk_every(3)
    |> Enum.map(&parse_number/1)
    |> intersperse(@scales, [])
    |> Enum.filter(fn str -> str != "" end)
    |> Enum.join(" ")
    |> (fn str -> {:ok, str} end).()
  end

  defp parse_number([u]), do: @simple_numbers |> Enum.at(u)

  defp parse_number([u, 0]), do: parse_number([u])
  defp parse_number([u, 1]), do: @composite_numbers |> Map.get(1) |> Enum.at(u)
  defp parse_number([0, d]), do: @composite_numbers |> Map.get(d)

  defp parse_number([u, d]),
    do: "#{@composite_numbers |> Map.get(d)}-#{@simple_numbers |> Enum.at(u)}"

  defp parse_number([0, 0, 0]), do: ""
  defp parse_number([u, 0, 0]), do: parse_number([u])
  defp parse_number([0, d, 0]), do: parse_number([0, d])
  defp parse_number([u, d, 0]), do: parse_number([u, d, 0])
  defp parse_number([0, 0, c]), do: "#{@simple_numbers |> Enum.at(c)} hundred"
  defp parse_number([u, 0, c]), do: "#{parse_number([0, 0, c])} and #{parse_number([u])}"
  defp parse_number([u, d, c]), do: "#{parse_number([0, 0, c])} #{parse_number([u, d])}"

  defp intersperse([hd | []], _, acc), do: [hd | acc]
  defp intersperse(["", "" | tl], [_ | sctl], acc), do: intersperse(["" | tl], sctl, acc)
  defp intersperse([hd | tl], [sc | sctl], acc), do: intersperse(tl, sctl, [sc | [hd | acc]])
end
