defmodule Bowling do
  @enforce_keys [:idx, :frame, :frames, :ended?]
  defstruct [:idx, :frame, :frames, :ended?]

  @type score :: non_neg_integer()

  @type frame ::
          :strike
          | {:spare, score(), score()}
          | {:open, score(), score()}
          | {:ongoing, score()}
          | {:bonus, score() | nil}
          | {:bonus, score() | nil, score() | nil}

  @type t :: %__MODULE__{
          idx: non_neg_integer() | :fill_ball,
          frame: frame() | nil,
          frames: [frame()],
          ended?: boolean()
        }

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: t()
  def start(), do: %__MODULE__{idx: 1, frame: nil, frames: [], ended?: false}

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """
  @spec roll(t(), integer) :: {:ok, t()} | {:error, String.t()}
  def roll(_, roll) when roll < 0, do: {:error, "Negative roll is invalid"}
  def roll(_, roll) when roll > 10, do: {:error, "Pin count exceeds pins on the lane"}
  def roll(%__MODULE__{ended?: true}, _), do: {:error, "Cannot roll after game is over"}

  # fill ball for spare
  def roll(%__MODULE__{idx: idx, frame: {:bonus, nil}} = game, roll) when idx >= 10,
    do: {:ok, push_frame(game, {:bonus, roll}, nil, true)}

  # roll + fill ball for strike
  def roll(%__MODULE__{idx: idx, frame: {:bonus, _, _} = bonus} = game, roll) when idx >= 10 do
    case bonus do
      {:bonus, nil, nil} ->
        {:ok, %__MODULE__{game | frame: {:bonus, roll, nil}}}

      {:bonus, 10, nil} ->
        {:ok, push_frame(game, {:bonus, 10, roll}, nil, true)}

      {:bonus, val, nil} when val + roll <= 10 ->
        {:ok, push_frame(game, {:bonus, val, roll}, nil, true)}

      _ ->
        {:error, "Pin count exceeds pins on the lane"}
    end
  end

  # strike on tenth guarantees one roll + one fill ball
  def roll(%__MODULE__{idx: idx, frame: nil} = game, 10) when idx >= 10,
    do: {:ok, push_frame(game, :strike, {:bonus, nil, nil})}

  def roll(%__MODULE__{idx: idx, frame: {:ongoing, pins}} = game, roll) when idx >= 10 do
    cond do
      pins + roll == 10 ->
        {:ok, push_frame(game, {:spare, pins, roll}, {:bonus, nil})}

      pins + roll > 10 ->
        {:error, "Pin count exceeds pins on the lane"}

      true ->
        {:ok, push_frame(game, {:open, pins, roll}, nil, true)}
    end
  end

  def roll(%__MODULE__{frame: nil} = game, 10),
    do: {:ok, push_frame(game, :strike)}

  def roll(%__MODULE__{frame: nil} = game, roll),
    do: {:ok, %__MODULE__{game | frame: {:ongoing, roll}}}

  def roll(%__MODULE__{frame: {:ongoing, pins}}, roll) when pins + roll > 10,
    do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%__MODULE__{frame: {:ongoing, pins}} = game, roll) when pins + roll == 10,
    do: {:ok, push_frame(game, {:spare, pins, roll})}

  def roll(%__MODULE__{frame: {:ongoing, pins}} = game, roll) when pins + roll < 10,
    do: {:ok, push_frame(game, {:open, pins, roll})}

  defp push_frame(game, finished_frame, next_frame \\ nil, finish? \\ false) do
    %__MODULE__{
      idx: game.idx + 1,
      frame: next_frame,
      frames: [finished_frame | game.frames],
      ended?: finish?
    }
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.
  """
  @spec score(t()) :: {:ok, integer} | {:error, String.t()}
  def score(%__MODULE__{ended?: false}),
    do: {:error, "Score cannot be taken until the end of the game"}

  def score(%__MODULE__{frames: frames}) do
    frames
    |> Enum.reverse()
    |> do_score(1, 0)
  end

  defp do_score([:strike | tl], idx, acc),
    do: do_score(tl, idx + 1, acc + 10 + Enum.sum(fetch_next_throws(tl, 2)))

  defp do_score([{:spare, x, y} | tl], idx, acc),
    do: do_score(tl, idx + 1, acc + x + y + Enum.sum(fetch_next_throws(tl, 1)))

  defp do_score([{:open, x, y} | tl], idx, acc),
    do: do_score(tl, idx + 1, acc + x + y)

  defp do_score(_, _, acc), do: {:ok, acc}

  defp fetch_next_throws([:strike | _tl], 1), do: [10]
  defp fetch_next_throws([{:bonus, fst} | _tl], 1), do: [fst]
  defp fetch_next_throws([{_type, fst, _snd} | _tl], 1), do: [fst]
  defp fetch_next_throws([{_type, fst, snd} | _tl], 2), do: [fst, snd]

  defp fetch_next_throws([:strike, snd | _tl], 2) do
    case snd do
      :strike -> [10, 10]
      {:bonus, val} -> [10, val]
      {_type, val, _other} -> [10, val]
    end
  end
end
