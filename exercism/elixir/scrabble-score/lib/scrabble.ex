defmodule GenMap do
  @raw_data """
  A, E, I, O, U, L, N, R, S, T       1
  D, G                               2
  B, C, M, P                         3
  F, H, V, W, Y                      4
  K                                  5
  J, X                               8
  Q, Z                               10
  """

  @capture_letters ~r/(?<letters>[A-Z])+/
  @capture_value ~r/(?<value>1{0,1}[0-9])+/

  def gen() do
    @raw_data
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> List.flatten()
    |> Enum.into(%{})
  end

  def parse_line(line) do
    value = @capture_value |> Regex.run(line) |> List.first() |> String.to_integer()

    @capture_letters
    |> Regex.scan(line)
    |> Enum.map(fn [l, _] -> {l, value} end)
  end
end

defmodule Scrabble do
  @scrabble_map GenMap.gen()

  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(""), do: 0

  def score(word) do
    word
    |> String.upcase()
    |> String.split("")
    |> Enum.frequencies()
    |> Enum.reduce(0, fn {k, v}, acc ->
      @scrabble_map |> Map.get(k, 0) |> Kernel.*(v) |> Kernel.+(acc)
    end)
  end
end
