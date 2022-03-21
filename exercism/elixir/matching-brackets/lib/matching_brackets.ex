defmodule Stack do
  def push(stack, value), do: [value | stack]

  def pop([head | tail]), do: {tail, head}
  def pop([]), do: {[], nil}
end

defmodule MatchingBrackets do
  @open ["(", "[", "{"]
  @close [")", "]", "}"]

  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> String.codepoints()
    |> Enum.filter(&only_brackets/1)
    |> do_check([])
  end

  defp only_brackets(char), do: char in @open or char in @close

  defp do_check([], []), do: true
  defp do_check([], _), do: false

  defp do_check([head | tail], stack) when head in @open do
    do_check(tail, Stack.push(stack, head))
  end

  defp do_check([head | tail], stack) when head in @close do
    {st, elem} = Stack.pop(stack)

    cond do
      elem == "(" and head == ")" -> do_check(tail, st)
      elem == "[" and head == "]" -> do_check(tail, st)
      elem == "{" and head == "}" -> do_check(tail, st)
      true -> false
    end
  end
end
