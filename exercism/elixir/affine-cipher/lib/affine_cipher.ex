defmodule AffineCipher do
  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    if not coprime?(a, 26) do
      throw({:error, "a and m must be coprime."})
    end

    fun = fn i -> (a * i + b) |> rem(26) |> Kernel.+(?a) end

    message
    |> String.downcase()
    |> do_shift(fun, <<>>)
    |> String.split("", trim: true)
    |> Enum.chunk_every(5)
    |> Enum.join(" ")
    |> (fn encoded_message -> {:ok, encoded_message} end).()
  catch
    error -> error
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    if not coprime?(a, 26) do
      throw({:error, "a and m must be coprime."})
    end

    x = mmi(a)

    fun = fn y ->
      numerical_value = (x * (y - b)) |> rem(26)
      if numerical_value >= 0, do: numerical_value + ?a, else: numerical_value + ?z + 1
    end

    encrypted
    |> do_shift(fun, <<>>)
    |> (fn decoded_message -> {:ok, decoded_message} end).()
  catch
    error -> error
  end

  defp do_shift(<<char, rest::binary>>, fun, acc) when ?a <= char and char <= ?z do
    shifted_value = fun.(char - ?a)
    do_shift(rest, fun, <<acc::binary, shifted_value::8>>)
  end

  defp do_shift(<<char, rest::binary>>, fun, acc) when ?0 <= char and char <= ?9 do
    do_shift(rest, fun, <<acc::binary, char>>)
  end

  defp do_shift(<<_, rest::binary>>, fun, acc), do: do_shift(rest, fun, acc)

  defp do_shift(<<>>, _, acc), do: acc

  defp mmi(n), do: Enum.find(0..25, &(rem(n * &1, 26) == 1))

  defp coprime?(a, b), do: Integer.gcd(a, b) == 1
end
