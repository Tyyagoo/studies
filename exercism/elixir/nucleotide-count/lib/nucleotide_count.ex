defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count(charlist(), char()) :: non_neg_integer()
  def count(strand, nucleotide), do: do_count(strand, nucleotide, 0)

  defp do_count([], _, acc), do: acc

  defp do_count([head | tail], nucleotide, acc) when head == nucleotide,
    do: do_count(tail, nucleotide, acc + 1)

  defp do_count([_ | tail], nucleotide, acc), do: do_count(tail, nucleotide, acc)

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram(charlist()) :: map()
  def histogram(strand), do: Map.new(@nucleotides, &{&1, count(strand, &1)})
end
