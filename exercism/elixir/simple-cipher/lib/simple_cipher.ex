defmodule SimpleCipher do
  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, key) do
    {plaintext_cl, key_alphabet} = prepare(plaintext, key)

    shifter = fn letter, key ->
      shift_amount = key - ?a
      shifted = letter + shift_amount
      if shifted > ?z, do: shifted - ?z + ?a - 1, else: shifted
    end

    do_shift(plaintext_cl, key_alphabet, shifter, [])
  end

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key) do
    {ciphertext_cl, key_alphabet} = prepare(ciphertext, key)

    shifter = fn letter, key ->
      shift_amount = key - ?a
      shifted = letter - shift_amount
      if shifted < ?a, do: ?z - (?a - shifted) + 1, else: shifted
    end

    do_shift(ciphertext_cl, key_alphabet, shifter, [])
  end

  @doc """
  Generate a random key of a given length. It should contain lowercase letters only.
  """
  def generate_key(length) do
    random = fn _ ->
      :rand.uniform(?z - ?a) + ?a
    end

    Stream.iterate(random.(0), random)
    |> Enum.take(length)
    |> to_string()
  end

  defp prepare(text, key) do
    text_cl = String.to_charlist(text)

    key_alphabet =
      key
      |> String.to_charlist()
      |> Stream.cycle()
      |> Enum.take(length(text_cl))

    {text_cl, key_alphabet}
  end

  defp do_shift([hp | tp], [hk | tk], shifter, acc),
    do: do_shift(tp, tk, shifter, [shifter.(hp, hk) | acc])

  defp do_shift([], _, _, acc), do: acc |> Enum.reverse() |> to_string()
end
