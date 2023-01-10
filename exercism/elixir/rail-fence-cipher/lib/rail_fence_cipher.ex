defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1), do: str
  def encode(str, rails) do
    do_encode(str, rails, 0, 1, %{})
    |> Enum.map_join("", fn {_, ls} -> Enum.reverse(ls) end)
  end

  defp do_encode(<<>>, _, _, _, acc), do: acc
  defp do_encode(str, rails, -1, _dir, acc), do: do_encode(str, rails, 1, 1, acc)
  defp do_encode(str, limit, limit, _dir, acc), do: do_encode(str, limit, limit - 2, -1, acc)
  defp do_encode(<<letter::utf8, rest::binary>>, rails, idx, dir, acc) do
    do_encode(rest, rails, idx + dir, dir, Map.update(acc, idx, [letter], fn ls -> [letter | ls] end))
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) do
  end
end
