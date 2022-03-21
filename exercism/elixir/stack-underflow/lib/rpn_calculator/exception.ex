defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    @default "stack underflow occurred"
    defexception message: @default

    @impl true
    def exception(value) do
      case value do
        [] -> %__MODULE__{}
        msg -> %__MODULE__{message: "#{@default}, context: #{msg}"}
      end
    end
  end

  def divide([0, _]), do: raise(DivisionByZeroError)
  def divide([x, y]), do: div(y, x)
  def divide(_), do: raise(StackUnderflowError, "when dividing")
end
