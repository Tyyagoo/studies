defmodule CryptoSquare do
  defguardp is_downcase(char) when ?a <= char and char <= ?z
  defguardp is_uppercase(char) when ?A <= char and char <= ?Z
  defguardp is_numerical(char) when ?0 <= char and char <= ?9
  defguardp is_downcase_or_numerical(char) when is_downcase(char) or is_numerical(char)
  defguardp is_valid_rectangle(l, r, c) when r * c >= l and c >= r and c - r <= 1

  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(str) do
    str
    |> normalize(<<>>)
    |> chunk_by_length()
    |> do_encode([], [], [])
    |> Enum.map(fn row -> Enum.reduce(row, "", &<>/2) end)
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  defp normalize(<<letter, rest::binary>>, acc) when is_downcase_or_numerical(letter) do
    normalize(rest, <<letter, acc::binary>>)
  end

  defp normalize(<<letter, rest::binary>>, acc) when is_uppercase(letter) do
    downcased = letter + (?a - ?A)
    normalize(rest, <<downcased, acc::binary>>)
  end

  defp normalize(<<_, rest::binary>>, acc), do: normalize(rest, acc)
  defp normalize(<<>>, acc), do: acc

  defp find_rectangle(len, r, c) when is_valid_rectangle(len, r, c), do: {r, c}
  defp find_rectangle(len, r, c) when c - r < 1, do: find_rectangle(len, r, c + 1)
  defp find_rectangle(len, r, c), do: find_rectangle(len, r + 1, c)

  defp chunk_by_length(""), do: [[""]]

  defp chunk_by_length(message) do
    {_, c} = find_rectangle(String.length(message), 0, 1)

    message
    |> String.split("", trim: true)
    |> Enum.reverse()
    |> Enum.chunk_every(c, c, Stream.cycle([" "]))
  end

  defp do_encode([[letter | rest] | tail], rem, chunk, acc),
    do: do_encode(tail, [rest | rem], [letter | chunk], acc)

  defp do_encode([], [], [], acc), do: acc
  defp do_encode([[] | tail], rem, chunk, acc), do: do_encode(tail, rem, chunk, acc)
  defp do_encode([], rem, chunk, acc), do: do_encode(Enum.reverse(rem), [], [], [chunk | acc])
end
