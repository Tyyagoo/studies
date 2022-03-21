defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> String.to_charlist()
    |> do_shift([])
    |> Enum.chunk_every(5)
    |> Enum.join(" ")
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> String.to_charlist()
    |> do_shift([])
    |> to_string()
  end

  defp do_shift([head | tail], acc) when ?a <= head and head <= ?z do
    do_shift(tail, [?z - head + ?a | acc])
  end

  defp do_shift([head | tail], acc) when ?A <= head and head <= ?Z do
    do_shift([head + (?a - ?A) | tail], acc)
  end

  defp do_shift([head | tail], acc) when ?1 <= head and head <= ?9 do
    do_shift(tail, [head | acc])
  end

  defp do_shift([_ | tail], acc), do: do_shift(tail, acc)
  defp do_shift([], acc), do: acc |> Enum.reverse()
end
