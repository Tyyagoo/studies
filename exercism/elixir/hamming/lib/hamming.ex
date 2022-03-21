defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) when length(strand1) != length(strand2), do: {:error, "strands must be of equal length"}
  def hamming_distance(strand1, strand2), do: do_hamming_distance(strand1, strand2, 0)

  defp do_hamming_distance([], [], diff), do: {:ok, diff}
  defp do_hamming_distance([h1 | t1], [h2|t2], diff) do
    do_hamming_distance(t1, t2, (if h1 != h2, do: diff + 1, else: diff))
  end
end
