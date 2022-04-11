defmodule Exercises.Macros do
  import Kernel, except: [unless: 2]

  @doc """
  Write a macro called myunless that implements the standard unless
  functionality. You’re allowed to use the regular if expression in it.
  """
  defmacro unless(condition, clauses) do
    do_ = Keyword.get(clauses, :do)
    else_ = Keyword.get(clauses, :else)

    quote do
      if unquote(condition) do
        unquote(else_)
      else
        unquote(do_)
      end
    end
  end

  @doc """
  Write a macro called times_n that takes a single numeric argument. It
  should define a function called times_n in the caller’s module that itself
  takes a single argument, and that multiplies that argument by n. So,
  calling times_n(3) should create a function called times_3, and calling times_3(4)
  should return 12.
  """

  defmacro times_n(n) do
    fn_name = String.to_atom("times_#{n}")

    quote do
      def unquote(fn_name)(x), do: unquote(n) * x
    end
  end

  @doc """
  (Hard) Once you’ve done that, see if you can use the same technique to
  implement a function that takes an arbitrary arithmetic expression and
  returns a natural-language version.
  """
  defmacro explain(do: expr) do
    expr
    |> Macro.prewalk([], &{&1, [&1 | &2]})
    |> elem(1)
    |> Enum.filter(&is_tuple/1)
    |> Enum.map(fn {operator, _, args} -> ast_expr_to_str(operator, args) end)
    |> Enum.join(", ")
    |> Macro.escape()
  end

  defp ast_expr_to_str(operator, [n1, n2]) when is_number(n1) and is_number(n2) do
    case operator do
      :+ -> "sum #{n1} and #{n2}"
      :- -> "subtract #{n2} from #{n1}"
      :* -> "multiply #{n1} and #{n2}"
      :/ -> "divide #{n1} by #{n2}"
    end
  end

  defp ast_expr_to_str(operator, [n1, n2]) do
    number = if is_number(n1), do: n1, else: n2

    case operator do
      :+ -> "then add #{number}"
      :- -> "then subtract #{number}"
      :* -> "then multiply by #{number}"
      :/ -> "then divide by #{number}"
    end
  end
end
