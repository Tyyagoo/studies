defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    input = input |> String.trim()
    yell = input == String.upcase(input) and input != String.downcase(input)
    question = input |> String.ends_with?("?")

    cond do
      input == "" -> "Fine. Be that way!"
      yell and question -> "Calm down, I know what I'm doing!"
      yell -> "Whoa, chill out!"
      question -> "Sure."
      true -> "Whatever."
    end
  end
end
