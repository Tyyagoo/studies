defmodule ListsAndRecursion do
  @doc """
  Exercise 1
  Write a mapsum function that takes a list and a function. It applies the
  function to each element of the list and then sums the result.
  
  ## Examples
  
      iex> import ListsAndRecursion
      ListsAndRecursion
      iex> mapsum([1, 2, 3], &(&1 * &1))
      14
  """
  @spec mapsum(list, (integer -> integer)) :: integer
  def mapsum(list, fun), do: reduce(list, 0, &(fun.(&1) + &2))

  @doc """
  Write a max(list) that returns the element with
  the maximum value in the list.
  
  ## Examples
  
      iex> import ListsAndRecursion
      ListsAndRecursion
      iex> max([])
      nil
      iex> max([5, 2, 10])
      10
      iex> max([-200, -1, -50])
      -1
  """
  @spec max(list) :: integer | nil
  def max([]), do: nil
  def max([hd | tl]), do: reduce(tl, hd, &if(&1 > &2, do: &1, else: &2))

  @doc """
  Write a caesar(list, n) function that adds n to each list element,
  wrapping if the addition results in a character greater than z.
  
  ## Examples
  
      iex> import ListsAndRecursion
      ListsAndRecursion
      iex> caesar('mwzera', 1)
      'nxafsb'
      iex> caesar('LOUD aspas', 13)
      'YBHQ nfcnf'
  """
  @spec caesar(charlist, integer) :: charlist
  def caesar(charlist, key) do
    alpha_size = ?z - ?a + 1
    key = rem(key, alpha_size)

    charlist
    |> reduce([], fn
      ?\s, acc ->
        [?\s | acc]

      char, acc when char <= ?Z ->
        [rem(char - ?A + key, alpha_size) + ?A | acc]

      char, acc ->
        [rem(char - ?a + key, alpha_size) + ?a | acc]
    end)
    |> reverse()
  end

  @doc """
  Write a function MyList.span(from, to) that returns a list of the numbers from
  from up to to.
  
  ## Examples
  
      iex> import ListsAndRecursion
      ListsAndRecursion
      iex> span(1, 5)
      [1, 2, 3, 4]
      iex> span(-9, -4)
      [-9, -8, -7, -6, -5]
  """
  @spec span(integer, integer) :: [integer]
  def span(from, to) when from < to, do: do_span(from, to, [])

  defp do_span(to, to, acc), do: acc |> reverse()
  defp do_span(from, to, acc), do: do_span(from + 1, to, [from | acc])

  # Implement the following Enum functions using no library functions or list
  # comprehensions: all?, each, filter, split, and take

  @doc """
    ## Examples
  
      iex> import ListsAndRecursion
      ListsAndRecursion
      iex> even? = & rem(&1, 2) == 0
      iex> all?([1, 2, 3], even?)
      false
      iex> all?([2, 4, 6], even?)
      true
      iex> all?([], fn _ -> false end)
      true
  """
  @spec all?(list, (any -> boolean)) :: boolean
  def all?([], _fun), do: true
  def all?([hd | tl], fun), do: if(fun.(hd), do: all?(tl, fun), else: false)

  @doc """
    ## Examples
  
      iex> import ListsAndRecursion
      ListsAndRecursion
      iex> each([], &IO.puts/1)
      :ok
      iex> each([1, 2, 3], &IO.puts/1)
      :ok
  """
  @spec each(list, (any -> any)) :: :ok
  def each(list, fun) do
    reduce(list, :ok, fn x, :ok ->
      fun.(x)
      :ok
    end)
  end

  @doc """
    ## Examples
  
      iex> import ListsAndRecursion
      ListsAndRecursion
      iex> even? = & rem(&1, 2) == 0
      iex> filter([1, 2, 3, 4], even?)
      [2, 4]
      iex> filter([2, 4, 6], &not even?.(&1))
      []
      iex> filter([], fn _ -> true end)
      []
  """
  @spec filter(list, (any -> boolean)) :: list
  def filter(list, fun) do
    list
    |> reduce([], fn element, acc ->
      if fun.(element), do: [element | acc], else: acc
    end)
    |> reverse()
  end

  @spec split(list, non_neg_integer) :: {list, list}
  def split(list, at) when at >= 0, do: do_split_at(list, 0, at, [])

  defp do_split_at(list, x, x, acc), do: {reverse(acc), list}
  defp do_split_at([], _, _, acc), do: {reverse(acc), []}
  defp do_split_at([hd | tl], from, to, acc), do: do_split_at(tl, from + 1, to, [hd | acc])

  @spec take(list, non_neg_integer) :: list
  def take(list, amount) when amount >= 0 do
    {items, _rest} = split(list, amount)
    items
  end

  @doc """
  Write a flatten(list) function that takes a list that may contain any
  number of sublists, which themselves may contain sublists, to any depth.
  It returns the elements of these lists as a flat list.
  
  ## Examples:
  
      iex> ListsAndRecursion.flatten([ 1, [ 2, 3, [4] ], 5, [[[6]]]])
      [1, 2, 3, 4, 5, 6]
  """
  @spec flatten(list) :: list
  def flatten(list), do: do_flatten(list, []) |> reverse()

  defp do_flatten([], acc), do: acc
  defp do_flatten([hd | tl], acc) when is_list(hd), do: do_flatten(tl, do_flatten(hd, acc))
  defp do_flatten([hd | tl], acc), do: do_flatten(tl, [hd | acc])

  @spec reduce(
          list,
          initial_acc :: any,
          (element :: any, acc :: any -> new_acc :: any)
        ) :: acc :: any
  defp reduce([], acc, _), do: acc
  defp reduce([hd | tl], acc, fun), do: reduce(tl, fun.(hd, acc), fun)

  @spec reverse(list) :: list
  defp reverse(list), do: reduce(list, [], &[&1 | &2])
end
