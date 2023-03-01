defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, rails) do
    str
    |> reduce_sink(move_through_rails(rails), %{}, &do_encode/3)
    |> join_map_values("", &Enum.reverse/1)
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode("", _rails), do: ""

  def decode(str, rails) do
    graphemes = String.graphemes(str)
    path = move_through_rails(rails)
    acc = 0..(rails - 1) |> Enum.map(&{&1, []}) |> Enum.into(%{})

    graphemes
    |> reduce_sink(path, acc, &do_pattern/3)
    |> join_map_values("\n")
    |> replace_wildcards(graphemes)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.replace(&1, "💀", ""))
    |> reduce_sink(path, [], &read_rails/3)
  end

  defp move_through_rails(1), do: Stream.cycle([0])

  defp move_through_rails(rails) do
    down = 0..(rails - 1)
    up = (rails - 2)..1

    Stream.concat(down, up)
    |> Stream.cycle()
  end

  defp reduce_sink(sink, path, acc, fun),
    do: Enum.reduce_while(path, {acc, sink}, fn idx, {acc, sink} -> fun.(idx, sink, acc) end)

  defp replace_wildcards(pattern, graphemes),
    do: Enum.reduce(graphemes, pattern, &String.replace(&2, "?", &1, global: false))

  defp do_encode(_, <<>>, acc), do: {:halt, acc}

  defp do_encode(idx, <<x::utf8, xs::binary>>, acc) do
    acc
    |> Map.update(idx, [x], &[x | &1])
    |> then(&{:cont, {&1, xs}})
  end

  defp do_pattern(_, [], acc), do: {:halt, acc}

  defp do_pattern(idx, [_x | xs], acc) do
    acc
    |> update_all_except(idx, &["💀" | &1])
    |> Map.update(idx, ["?"], &["?" | &1])
    |> then(&{:cont, {&1, xs}})
  end

  defp read_rails(idx, rails, acc) do
    case Enum.at(rails, idx) do
      <<>> ->
        {:halt, acc |> Enum.reverse() |> to_string()}

      <<x::utf8, xs::binary>> ->
        rails
        |> List.update_at(idx, fn _ -> xs end)
        |> then(&{:cont, {[x | acc], &1}})
    end
  end

  defp update_all_except(map, exception, fun) do
    map
    |> Enum.map(fn
      {^exception, _} = keep -> keep
      {key, value} -> {key, fun.(value)}
    end)
    |> Enum.into(%{})
  end

  defp join_map_values(map, joiner, fun \\ & &1),
    do: Enum.map_join(map, joiner, fn {_key, val} -> fun.(val) end)
end
