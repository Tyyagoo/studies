defmodule Clock do
  defstruct hour: 0, minute: 0

  @type t :: %__MODULE__{hour: non_neg_integer(), minute: non_neg_integer()}

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: t
  def new(hour, minute) when hour < 0, do: new(24 + rem(hour, 24), minute)
  def new(hour, minute), do: %__MODULE__{hour: rem(hour, 24)} |> add(minute)

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(t, integer) :: t
  def add(%__MODULE__{hour: hour, minute: minute}, add_minute) when minute + add_minute >= 0 do
    m = minute + add_minute
    %__MODULE__{hour: rem(hour + div(m, 60), 24), minute: rem(m, 60)}
  end

  def add(%__MODULE__{hour: hour, minute: minute}, add_minute) do
    hour = if hour - 1 < 0, do: 23, else: hour - 1
    add(%__MODULE__{hour: hour, minute: minute}, add_minute + 60)
  end

  defimpl String.Chars do
    def to_string(%Clock{hour: h, minute: m}), do: "#{pad_left(h)}:#{pad_left(m)}"

    defp pad_left(n), do: n |> Integer.to_string() |> String.pad_leading(2, "0")
  end
end
