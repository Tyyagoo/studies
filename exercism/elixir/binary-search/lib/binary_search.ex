defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search({}, _), do: :not_found

  def search(numbers, key) do
    size = tuple_size(numbers)
    do_search(numbers, key, 0, size - 1)
  end

  defp do_search(_, _, lower, upper) when lower > upper, do: :not_found

  defp do_search(numbers, key, lower, upper) do
    middle = div(upper - lower, 2) + lower
    element = elem(numbers, middle)

    cond do
      key == element -> {:ok, middle}
      key < element -> do_search(numbers, key, lower, middle - 1)
      key > element -> do_search(numbers, key, middle + 1, upper)
    end
  end
end
