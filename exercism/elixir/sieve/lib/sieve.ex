defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(1), do: []
  def primes_to(2), do: [2]

  def primes_to(limit) do
    limit
    |> generate_odd_list()
    |> Map.new(&{&1, :prime})
    |> sieve(3, limit)
    |> Map.keys()
    |> Enum.sort()
    |> (fn primes -> [2 | primes] end).()
  end

  defp generate_odd_list(limit, start \\ 3) do
    Stream.iterate(start, fn x -> x + 2 end)
    |> Enum.take_while(fn x -> x <= limit end)
  end

  defp sieve(map, number, limit) when number * number <= limit do
    map = if Map.has_key?(map, number), do: remove_all_multiples(map, number, limit), else: map
    sieve(map, number + 2, limit)
  end

  defp sieve(map, _, _), do: map

  defp remove_all_multiples(map, number, limit) do
    multiples =
      Stream.iterate(number * number, fn n -> n + number end)
      |> Enum.take_while(fn n -> n <= limit end)

    Map.drop(map, multiples)
  end
end
