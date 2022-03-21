defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    integers
    |> Enum.map(&do_encode/1)
    |> Enum.join("")
  end

  defp do_encode(integer) do
    <<x1::7, x2::7, x3::7, x4::7, x5::7>> = <<0::3, integer::32>>

    [x1, x2, x3, x4, x5]
    |> Enum.drop_while(fn septet -> septet == 0 end)
    |> reduce()
  end

  defp reduce([]), do: <<0>>
  defp reduce(list), do: do_reduce(list, <<>>)

  defp do_reduce([head | []], acc), do: <<acc::binary, 0::1, head::7>>
  defp do_reduce([head | tail], acc), do: do_reduce(tail, <<acc::binary, 1::1, head::7>>)

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes) do
    decompressed = bytes |> do_decode([], []) |> Enum.reverse()

    case decompressed do
      [] -> {:error, "incomplete sequence"}
      integers -> {:ok, integers}
    end
  end

  defp do_decode(<<0::1, byte::7, rest::binary>>, integers, acc) do
    lst = [<<1::1, byte::7>> | acc]
    do_decode(rest, [lst | integers], [])
  end

  defp do_decode(<<1::1, byte::7, rest::binary>>, integers, acc) do
    lst = [<<1::1, byte::7>> | acc]
    do_decode(rest, integers, lst)
  end

  defp do_decode(_, integers, _) do
    integers
    |> Enum.map(fn lst -> merge(lst, 0, <<0::35>>) end)
  end

  defp merge([<<_::1, head::7>> | tail], position, total) do
    sb = position * 7
    sf = 35 - sb - 7
    <<front::size(sf), _::7, back::size(sb)>> = total
    f = <<front::size(sf)>>
    b = <<back::size(sb)>>
    merge(tail, position + 1, <<f::bitstring, head::7, b::bitstring>>)
  end

  defp merge([], _, total) do
    <<0::3, n::32>> = total
    n
  end
end
