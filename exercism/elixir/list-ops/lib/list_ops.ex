defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: reduce(l, 0, fn _, acc -> acc + 1 end)

  @spec reverse(list) :: list
  def reverse(l), do: prepend_each(l, [])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: reduce(l, [], fn x, acc -> [f.(x) | acc] end) |> reverse()

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    l
    |> reduce([], fn x, acc ->
      if f.(x), do: [x | acc], else: acc
    end)
    |> reverse()
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl(l, acc, f), do: reduce(l, acc, f)

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr(l, acc, f), do: l |> reverse() |> reduce(acc, f)

  @spec append(list, list) :: list
  def append(a, b), do: prepend_each(b, prepend_each(a, [])) |> reverse()

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    ll
    |> reduce([], &prepend_each/2)
    |> reverse()
  end

  defp reduce([hd | tl], acc, fun), do: reduce(tl, fun.(hd, acc), fun)
  defp reduce([], acc, _), do: acc

  # preprends each list element into an accumulator
  defp prepend_each([hd | tl], acc), do: prepend_each(tl, [hd | acc])
  defp prepend_each([], acc), do: acc
end
