defmodule Transpose do
  @ghost "ㅤ"

  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(input) do
    input
    |> String.split("\n")
    |> uniformize()
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip_with(& &1)
    |> Enum.map_join("\n", fn row ->
      row
      |> Enum.join()
      |> String.replace_trailing(@ghost, "")
      |> String.replace(@ghost, " ")
    end)
  end

  defp uniformize(enums) do
    target =
      enums
      |> Enum.map(&String.length/1)
      |> Enum.max()

    enums
    |> Enum.map(&String.pad_trailing(&1, target, @ghost))
  end
end
