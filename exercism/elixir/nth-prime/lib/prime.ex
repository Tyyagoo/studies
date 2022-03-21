defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count > 0 do
    Stream.unfold([2], fn [head | _] = acc ->
      n = next_prime(head + 1, acc)
      {n, [n | acc]}
    end)
    |> (fn primes -> Stream.concat([2], primes) end).()
    |> Stream.take(count)
    |> Enum.to_list()
    |> List.last()
  end

  defp prime?(_, []), do: true
  defp prime?(n, [h | _]) when rem(n, h) == 0, do: false
  defp prime?(n, [_ | t]), do: prime?(n, t)

  defp next_prime(n, primes) do
    if prime?(n, primes), do: n, else: next_prime(n + 1, primes)
  end
end
