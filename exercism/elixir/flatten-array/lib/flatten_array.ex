defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list), do: do_flatten(list, []) |> Enum.reverse()

  defp do_flatten([], acc), do: acc

  defp do_flatten([head | tail], acc) when is_list(head),
    do: do_flatten(tail, do_flatten(head, acc))

  defp do_flatten([head | tail], acc) when head != nil, do: do_flatten(tail, [head | acc])

  defp do_flatten([_ | tail], acc), do: do_flatten(tail, acc)
end
