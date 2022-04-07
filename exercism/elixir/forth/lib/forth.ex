defmodule Forth do
  defstruct stack: [],
            words: [],
            definition: %{}

  @opaque operation :: (evaluator() -> evaluator())
  @opaque word :: %{name: String.t(), code: [operation()]}
  @opaque evaluator :: %__MODULE__{stack: [integer()], words: [word()], definition: map()}

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %__MODULE__{}
    |> add_word("+", fn ev -> stack2!(ev).(&[&1 + &2 | &3]) end)
    |> add_word("-", fn ev -> stack2!(ev).(&[&2 - &1 | &3]) end)
    |> add_word("*", fn ev -> stack2!(ev).(&[&1 * &2 | &3]) end)
    |> add_word("/", fn ev -> stack2!(ev).(&[div!(&2, &1) | &3]) end)
    |> add_word("dup", &stack1!(&1).(fn head, tail -> [head, head | tail] end))
    |> add_word("drop", &stack1!(&1).(fn _head, tail -> tail end))
    |> add_word("swap", &stack2!(&1).(fn x, y, tail -> [y, x | tail] end))
    |> add_word("over", &stack2!(&1).(fn x, y, tail -> [y, x, y | tail] end))
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(evaluator, input) do
    input
    |> String.replace(~r/[\x00\x01\n\r\t ]/, " ")
    |> String.downcase()
    |> String.split(" ", trim: true)
    |> do_eval(evaluator)
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(evaluator), do: evaluator.stack |> Enum.reverse() |> Enum.join(" ")

  @spec add_word(evaluator(), String.t(), operation()) :: evaluator()
  defp add_word(evaluator, name, fun) when is_function(fun) do
    word = %{name: name, code: [fun]}
    %__MODULE__{evaluator | words: [word | evaluator.words]}
  end

  @spec add_word(evaluator(), String.t(), [String.t()]) :: evaluator()
  defp add_word(evaluator, name, tokens) when is_list(tokens) do
    instructions =
      tokens
      |> Enum.map(fn token ->
        case Integer.parse(token) do
          {integer, _} ->
            &push(&1, integer)

          :error ->
            word = find_word!(evaluator, token)
            &Enum.reduce(word.code, &1, fn fun, ev -> fun.(ev) end)
        end
      end)

    word = %{name: name, code: instructions}
    %__MODULE__{evaluator | words: [word | evaluator.words]}
  end

  @spec find_word!(evaluator(), String.t()) :: word()
  defp find_word!(evaluator, name) do
    evaluator.words
    |> Enum.find(:no_word, fn word -> word.name == name end)
    |> case do
      :no_word -> raise UnknownWord
      word -> word
    end
  end

  @spec push(evaluator(), integer()) :: evaluator()
  defp push(evaluator, integer) do
    %__MODULE__{evaluator | stack: [integer | evaluator.stack]}
  end

  defp do_eval([":", name | tl], ev) do
    case Integer.parse(name) do
      :error -> do_eval(tl, %__MODULE__{ev | definition: %{name: name, instructions: []}})
      _ -> raise InvalidWord, word: name
    end
  end

  defp do_eval([";" | tl], %__MODULE__{definition: definition} = ev) do
    tokens = definition.instructions |> Enum.reverse()
    new_ev = %__MODULE__{add_word(ev, definition.name, tokens) | definition: %{}}
    do_eval(tl, new_ev)
  end

  defp do_eval([token | tl], ev) do
    case ev.definition do
      %{name: _, instructions: instructions} ->
        new_definition = %{ev.definition | instructions: [token | instructions]}
        new_ev = %__MODULE__{ev | definition: new_definition}
        do_eval(tl, new_ev)

      _ ->
        do_eval(tl, eval_token(token, ev))
    end
  end

  defp do_eval([], ev), do: ev

  defp eval_token(token, %__MODULE__{} = ev) do
    case Integer.parse(token) do
      {number, _} ->
        push(ev, number)

      :error ->
        ev
        |> find_word!(token)
        |> Map.fetch!(:code)
        |> Enum.reduce(ev, fn op, acc -> op.(acc) end)
    end
  end

  defp stack1!(%__MODULE__{stack: stack} = ev) do
    case stack do
      [head | tail] -> fn fun -> %__MODULE__{ev | stack: fun.(head, tail)} end
      _ -> fn _fun -> raise StackUnderflow end
    end
  end

  defp stack2!(%__MODULE__{stack: stack} = ev) do
    case stack do
      [x, y | tail] -> fn fun -> %__MODULE__{ev | stack: fun.(x, y, tail)} end
      _ -> fn _fun -> raise StackUnderflow end
    end
  end

  defp div!(_x, 0), do: raise(DivisionByZero)
  defp div!(x, y), do: div(x, y)
end
