defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    string
    |> String.split("", trim: true)
    |> do_encode("", 0, [])
    |> Enum.reduce("", &<>/2)
  end

  defp do_encode([], last_char, count, acc), do: [charcont(last_char, count) | acc]

  defp do_encode([h | _] = lst, "", 0, acc), do: do_encode(lst, h, 0, acc)

  defp do_encode([h | t], last_char, count, acc) when last_char == h,
    do: do_encode(t, h, count + 1, acc)

  defp do_encode([h | t], last_char, count, acc),
    do: do_encode(t, h, 1, [charcont(last_char, count) | acc])

  defp charcont(last_char, count) when count <= 1, do: last_char
  defp charcont(last_char, count), do: "#{count}#{last_char}"

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    ~r/(?<a>\d*)(?<b>(\w|\s))/
    |> Regex.scan(string, capture: :all_names)
    |> Enum.map(&decompress/1)
    |> Enum.reduce("", fn elem, acc -> acc <> elem end)
  end

  defp decompress(["", char]), do: char

  defp decompress([value, char]) do
    [char]
    |> Stream.cycle()
    |> Enum.take(String.to_integer(value))
    |> Enum.into("")
  end
end
