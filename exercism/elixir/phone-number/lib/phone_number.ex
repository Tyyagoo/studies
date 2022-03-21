defmodule PhoneNumber do
  defguardp is_numerical(c) when ?0 <= c and c <= ?9
  defguardp is_ignorable(c) when c == ?\s or c in '.()-'

  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    with {:ok, parsed_number} <- do_cleanup(raw, 0, <<>>),
         {:ok, _} <- validate_area_code(parsed_number),
         {:ok, _} <- validate_exchange_code(parsed_number) do
      {:ok, parsed_number}
    else
      e -> e
    end
  end

  defp do_cleanup(<<?+, _char, rest::binary>>, 0, acc) do
    do_cleanup(rest, 0, acc)
  end

  defp do_cleanup(<<char, rest::binary>>, count, acc) when is_numerical(char) do
    do_cleanup(rest, count + 1, <<acc::binary, char>>)
  end

  defp do_cleanup(<<char, rest::binary>>, count, acc) when is_ignorable(char) do
    do_cleanup(rest, count, acc)
  end

  # if the character isn't numerical or skippable, then it's an invalid
  defp do_cleanup(<<_, _rest::binary>>, _, _), do: {:error, "must contain digits only"}

  defp do_cleanup(<<>>, 10, acc), do: {:ok, acc}

  defp do_cleanup(<<>>, 11, <<?1, acc::binary>>), do: {:ok, <<acc::binary>>}
  defp do_cleanup(<<>>, 11, _), do: {:error, "11 digits must start with 1"}

  defp do_cleanup(<<>>, _, _), do: {:error, "incorrect number of digits"}

  defp validate_area_code(<<area_code::24, _::binary>>) do
    case <<area_code::24>> do
      <<?0, _::binary>> -> {:error, "area code cannot start with zero"}
      <<?1, _::binary>> -> {:error, "area code cannot start with one"}
      valid -> {:ok, valid}
    end
  end

  defp validate_exchange_code(<<_::24, exchange_code::24, _::binary>>) do
    case <<exchange_code::24>> do
      <<?0, _::binary>> -> {:error, "exchange code cannot start with zero"}
      <<?1, _::binary>> -> {:error, "exchange code cannot start with one"}
      valid -> {:ok, valid}
    end
  end
end
