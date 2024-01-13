defmodule TwoBucket do
  defstruct [:bucket_one, :bucket_two, :moves]
  @type t :: %TwoBucket{bucket_one: integer, bucket_two: integer, moves: integer}

  @doc """
  Find the quickest way to fill a bucket with some amount of water from two buckets of specific sizes.
  """
  @spec measure(
          size_one :: integer,
          size_two :: integer,
          goal :: integer,
          start_bucket :: :one | :two
        ) :: {:ok, TwoBucket.t()} | {:error, :impossible}
  def measure(size_one, size_two, goal, start_bucket) do
    b1 = {:bucket_one, size_one}
    b2 = {:bucket_two, size_two}
    {main, other} = if start_bucket == :one, do: {b1, b2}, else: {b2, b1}

    %{bucket_one: 0, bucket_two: 0, moves: 0}
    |> fill(main)
    |> do_measure(main, other, goal)
  end

  defp do_measure(%{bucket_one: x, bucket_two: y} = state, _, _, goal)
       when x == goal or y == goal,
       do: {:ok, struct(TwoBucket, state)}

  defp do_measure(state, _, _, _) when state.moves > 20, do: {:error, :impossible}

  defp do_measure(state, {main_key, _} = main, {other_key, other_size} = other, goal) do
    cond do
      other_size == goal -> fill(state, other)
      state[other_key] == other_size -> empty(state, other_key)
      state[main_key] == 0 -> fill(state, main)
      true -> pour(state, main, other)
    end
    |> do_measure(main, other, goal)
  end

  defp fill(state, {bucket, size}) do
    state
    |> Map.put(bucket, size)
    |> Map.update!(:moves, &(&1 + 1))
  end

  defp empty(state, bucket) do
    state
    |> Map.put(bucket, 0)
    |> Map.update!(:moves, &(&1 + 1))
  end

  defp pour(state, {main_key, _}, {other_key, other_size}) do
    state
    |> Map.update!(:moves, &(&1 + 1))
    |> Map.update!(main_key, &max(0, &1 + Map.get(state, other_key) - other_size))
    |> Map.update!(other_key, &min(&1 + Map.get(state, main_key), other_size))
  end
end