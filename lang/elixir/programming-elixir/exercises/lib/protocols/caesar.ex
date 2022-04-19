defprotocol Exercises.Protocols.Caesar do
  @spec encrypt(t(), pos_integer()) :: t()
  def encrypt(encryptable, shift)

  @spec rot13(t()) :: t()
  def rot13(encryptable)
end

defmodule Exercises.Protocols.Shifter do
  def shift(<<char::utf8>>, amount), do: shift(char, amount)

  def shift(char, amount) when char in ?a..?z do
    shifted = char + amount
    if shifted <= ?z, do: shifted, else: char + amount - ?z + ?a - 1
  end

  def shift(char, amount) when char in ?A..?Z do
    shifted = char + amount
    if shifted <= ?Z, do: shifted, else: char + amount - ?Z + ?A - 1
  end
end

defimpl Exercises.Protocols.Caesar, for: List do
  alias Exercises.Protocols.Shifter

  def encrypt(encryptable, shift) do
    do_encrypt(encryptable, &Shifter.shift(&1, shift), [])
  end

  def rot13(encryptable), do: encrypt(encryptable, 13)

  defp do_encrypt([hd | tl], shifter, acc), do: do_encrypt(tl, shifter, [shifter.(hd) | acc])
  defp do_encrypt([], _, acc), do: Enum.reverse(acc)
end

defimpl Exercises.Protocols.Caesar, for: BitString do
  alias Exercises.Protocols.Shifter

  def encrypt(encryptable, shift) do
    do_encrypt(encryptable, &Shifter.shift(&1, shift), <<>>)
  end

  def rot13(encryptable), do: encrypt(encryptable, 13)

  defp do_encrypt(<<char::utf8, rest::binary>>, shifter, acc) do
    shifted = shifter.(char)
    do_encrypt(rest, shifter, <<acc::binary, shifted::utf8>>)
  end

  defp do_encrypt(<<>>, _, acc), do: acc
end
