defmodule ResistorColorTrio do
  @color_codes %{
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  }

  @doc """
  Calculate the resistance value in ohm or kiloohm from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms}
  def label([c1, c2, c3]) do
    "#{@color_codes[c1]}#{@color_codes[c2]}"
    |> String.to_integer()
    |> Kernel.*(Integer.pow(10, @color_codes[c3]))
    |> (&if(&1 > 1000, do: {&1 / 1000, :kiloohms}, else: {&1, :ohms})).()
  end
end
