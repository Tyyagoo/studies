defmodule RobotSimulator do
  defstruct dir: nil, pos: nil

  @directions [:north, :east, :south, :west]

  defguardp is_valid_direction(dir) when dir in @directions

  defguardp is_valid_position(pos)
            when is_tuple(pos) and
                   tuple_size(pos) == 2 and
                   is_number(elem(pos, 0)) and
                   is_number(elem(pos, 1))

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(dir \\ :north, pos \\ {0, 0})
  def create(dir, _) when not is_valid_direction(dir), do: {:error, "invalid direction"}
  def create(_, pos) when not is_valid_position(pos), do: {:error, "invalid position"}
  def create(dir, pos), do: %__MODULE__{dir: dir, pos: pos}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.graphemes()
    |> Enum.map(fn
      "R" -> :turn_right
      "L" -> :turn_left
      "A" -> :advance
      _ -> throw({:error, "invalid instruction"})
    end)
    |> Enum.reduce(robot, &execute/2)
  catch
    error -> error
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%__MODULE__{dir: dir}), do: dir

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%__MODULE__{pos: pos}), do: pos

  defp execute(:turn_right, %__MODULE__{dir: dir} = robot) do
    index = @directions |> Enum.find_index(&(&1 == dir))
    %__MODULE__{robot | dir: Enum.at(@directions, index + 1, :north)}
  end

  defp execute(:turn_left, %__MODULE__{dir: dir} = robot) do
    index = @directions |> Enum.find_index(&(&1 == dir))
    %__MODULE__{robot | dir: Enum.at(@directions, index - 1)}
  end

  defp execute(:advance, %__MODULE__{pos: {x, y}} = robot) do
    case robot.dir do
      :north -> %__MODULE__{robot | pos: {x, y + 1}}
      :south -> %__MODULE__{robot | pos: {x, y - 1}}
      :east -> %__MODULE__{robot | pos: {x + 1, y}}
      :west -> %__MODULE__{robot | pos: {x - 1, y}}
    end
  end
end
