defmodule Exercises.Macros.Test do
  use ExUnit.Case, async: true
  use Exercises.Macros
  import ExUnit.CaptureIO, only: [capture_io: 1]
  alias Exercises.Traceable

  # Expand at RunTime, used to avoid invalid macro calls preventing compilation
  # of the tests.
  #
  # Inspired by (read: clone of) Support.CompileHelpers.delay_compile in Ecto.
  # ** from Exercism Elixir Track - DOT DSL exercise **
  defmacrop exprt(ast) do
    escaped = Macro.escape(ast)

    quote do
      Code.eval_quoted(unquote(escaped), [], __ENV__) |> elem(0)
    end
  end

  describe "when using unless macro" do
    test "it must execute :do clause" do
      assert :correct == exprt(unless false, do: :correct, else: :incorrect)
    end

    test "it must execute :else clause" do
      assert :correct == exprt(unless true, do: :incorrect, else: :correct)
    end
  end

  describe "when using times_n macro" do
    times_n(5)

    test "it must multiply 3 by 5" do
      assert 15 == times_5(3)
    end
  end

  describe "when using explain macro" do
    test "it must handle simple sum" do
      assert "sum 2 and 1" == exprt(explain(do: 2 + 1))
    end

    test "it must handle simple subtraction" do
      assert "subtract 1 from 2" == exprt(explain(do: 2 - 1))
    end

    test "it must handle simple multiplication" do
      assert "multiply 5 and 2" == exprt(explain(do: 5 * 2))
    end

    test "it must handle simple division" do
      assert "divide 10 by 2" == exprt(explain(do: 10 / 2))
    end

    test "it must handle position priority" do
      assert "multiply 4 and 10, then divide by 2" == exprt(explain(do: 4 * 10 / 2))
    end

    test "it must handle multiplication priority" do
      assert "multiply 3 and 4, then add 2" == exprt(explain(do: 2 + 3 * 4))
    end

    test "it must handle division priority" do
      assert "divide 4 by 2, then add 2" == exprt(explain(do: 2 + 4 / 2))
    end

    test "it must handle parenthesis priority" do
      assert "sum 2 and 1, then multiply by 3" == exprt(explain(do: 3 * (2 + 1)))
    end

    test "it must handle a complex expression" do
      assert "sum 10 and 20, then divide by 2, then add 5, then multiply by 3, then divide by 5, then add 5, then subtract 2" ==
               exprt(
                 explain do
                   5 + 3 * ((10 + 20) / 2 + 5) / 5 - 2
                 end
               )
    end
  end

  describe "when using tracer" do
    test "it must handle function definitions with guards" do
      expected = "==> call `Exercises.Traceable.sum/2` with args: [10, 30]\n<== return 40\n"

      assert expected == capture_io(fn -> Traceable.sum(10, 30) end)
    end

    test "it must handle function definitions without guards" do
      expected =
        "==> call `Exercises.Traceable.print/1` with args: [{:ok, :all_good}]\n{:ok, :all_good}\n<== return {:ok, :all_good}\n"

      assert expected == capture_io(fn -> Traceable.print({:ok, :all_good}) end)
    end
  end
end
