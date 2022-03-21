defmodule PigLatin do
  defguardp is_vowel(c) when c in 'aeiou'
  defguardp is_consonant(c) when not is_vowel(c)

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(" ")
    |> Enum.map(&do_translate/1)
    |> Enum.join(" ")
  end

  defp do_translate(<<initial, _::binary>> = word) when is_vowel(initial), do: word <> "ay"
  defp do_translate(<<"x", c, _::binary>> = word) when is_consonant(c), do: word <> "ay"
  defp do_translate(<<"y", c, _::binary>> = word) when is_consonant(c), do: word <> "ay"
  defp do_translate(word), do: cluster_consonants(word, <<>>)

  defp cluster_consonants(<<"qu", rest::binary>>, acc), do: <<rest::binary, acc::binary, "quay">>

  defp cluster_consonants(<<initial, "y", rest::binary>>, acc) when is_consonant(initial),
    do: <<"y", rest::binary, acc::binary, initial, "ay">>

  defp cluster_consonants(<<initial, rest::binary>>, acc) when is_consonant(initial),
    do: cluster_consonants(rest, <<acc::binary, initial>>)

  defp cluster_consonants(rest, acc), do: <<rest::binary, acc::binary, "ay">>
end
