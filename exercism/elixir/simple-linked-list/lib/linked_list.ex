defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new(), do: {}

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem), do: {elem, list}

  @doc """
  Counts the number of elements in a LinkedList
  """
  @spec count(t) :: non_neg_integer()
  def count(list), do: list |> do_count(0)

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?({}), do: true
  def empty?(_), do: false

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({head, _}), do: {:ok, head}
  def peek(_), do: {:error, :empty_list}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({_, tail}), do: {:ok, tail}
  def tail(_), do: {:error, :empty_list}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({head, tail}), do: {:ok, head, tail}
  def pop(_), do: {:error, :empty_list}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list), do: list |> do_from_list(new()) |> reverse()

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list), do: list |> do_to_list([]) |> Enum.reverse()

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list) do
    list |> do_reverse(new())
  end

  defp do_count({}, acc), do: acc
  defp do_count({_, tail}, acc), do: do_count(tail, acc + 1)

  defp do_from_list([], acc), do: acc
  defp do_from_list([head | tail], acc), do: do_from_list(tail, push(acc, head))

  defp do_to_list({}, acc), do: acc
  defp do_to_list({head, tail}, acc), do: do_to_list(tail, [head | acc])

  defp do_reverse({}, acc), do: acc
  defp do_reverse({head, tail}, acc), do: do_reverse(tail, push(acc, head))
end
