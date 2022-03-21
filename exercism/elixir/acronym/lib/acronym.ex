defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.replace(~r/[_.,\-]/, " ")
    |> String.replace(~r/\s+/, " ")
    |> String.split(" ")
    |> Enum.reduce("", fn word, acc -> acc <> String.at(word, 0) end)
    |> String.upcase()
  end
end
