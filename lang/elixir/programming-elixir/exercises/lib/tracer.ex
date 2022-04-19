defmodule Exercises.Tracer do
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [def: 2]
      import unquote(__MODULE__), only: [def: 2]
    end
  end

  defmacro def(call, do: expr) do
    {name, args} =
      case call do
        {:when, _, [definition | _guards]} ->
          {name, _, args} = definition
          {name, args}

        {name, _, args} ->
          {name, args}
      end

    quote do
      Kernel.def unquote(call) do
        alias Exercises.Tracer

        signature = "#{inspect(__MODULE__)}.#{unquote(name)}/#{length(unquote(args))}"
        IO.puts("==> call `#{signature}` with args: [#{Tracer.format_args(unquote(args))}]")

        result = unquote(expr)
        IO.puts("<== return #{inspect(result)}")
        result
      end
    end
  end

  def format_args(args), do: args |> Enum.map(&inspect/1) |> Enum.join(", ")
end

defmodule Exercises.Traceable do
  use Exercises.Tracer

  def sum(x, y) when is_number(x) and is_number(y), do: x + y

  def print(val), do: IO.inspect(val)
end
