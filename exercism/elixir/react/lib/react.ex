defmodule React do
  use GenServer

  @opaque cells :: pid

  @typep input :: {:input, String.t(), any}
  @typep output :: {:output, String.t(), [String.t()], fun()}
  @type cell :: input | output

  @doc """
  Start a reactive system
  """
  @spec new(cells :: [cell]) :: {:ok, pid}
  def new(cells) do
    GenServer.start_link(__MODULE__, cells)
  end

  @doc """
  Return the value of an input or output cell
  """
  @spec get_value(cells :: pid, cell_name :: String.t()) :: any()
  def get_value(cells, cell_name) do
    GenServer.call(cells, {:get_value, cell_name})
  end

  @doc """
  Set the value of an input cell
  """
  @spec set_value(cells :: pid, cell_name :: String.t(), value :: any) :: :ok
  def set_value(cells, cell_name, value) do
    GenServer.cast(cells, {:set_value, cell_name, value})
  end

  @doc """
  Add a callback to an output cell
  """
  @spec add_callback(
          cells :: pid,
          cell_name :: String.t(),
          callback_name :: String.t(),
          callback :: fun()
        ) :: :ok
  def add_callback(cells, cell_name, callback_name, callback) do
    GenServer.cast(cells, {:add_callback, cell_name, callback_name, callback})
  end

  @doc """
  Remove a callback from an output cell
  """
  @spec remove_callback(cells :: pid, cell_name :: String.t(), callback_name :: String.t()) :: :ok
  def remove_callback(cells, cell_name, callback_name) do
    GenServer.cast(cells, {:remove_callback, cell_name, callback_name})
  end

  @impl GenServer
  def init(cells) do
    initial_state =
      cells
      |> Enum.reduce(%{input: Map.new(), output: Map.new(), output_order: []}, fn
        {:input, name, value}, acc ->
          new_input_map = Map.put(acc.input, name, value)
          %{acc | input: new_input_map}

        {:output, name, deps, fun}, acc ->
          output = %{name: name, deps: deps, value: 0, fun: fun, callbacks: Map.new()}
          new_output_map = Map.put(acc.output, name, output)
          new_output_order = [name | acc.output_order]
          new_acc = %{acc | output: new_output_map, output_order: new_output_order}

          compute_cell(new_acc, output)
      end)
      |> Map.update!(:output_order, &Enum.reverse/1)

    {:ok, initial_state}
  end

  @impl GenServer
  def handle_call({:get_value, cell_name}, _, state) do
    {:reply, find_cell_value!(state, cell_name), state}
  end

  @impl GenServer
  def handle_cast({:set_value, cell_name, value}, state) do
    new_state =
      Enum.reduce(
        state.output_order,
        %{state | input: Map.put(state.input, cell_name, value)},
        &compute_cell(&2, Map.fetch!(state.output, &1))
      )

    {:noreply, new_state}
  end

  def handle_cast({:add_callback, cell_name, callback_name, callback}, state) do
    new_state =
      update_in(state, [:output, cell_name, :callbacks], &Map.put(&1, callback_name, callback))

    {:noreply, new_state}
  end

  def handle_cast({:remove_callback, cell_name, callback_name}, state) do
    new_state = update_in(state, [:output, cell_name, :callbacks], &Map.delete(&1, callback_name))
    {:noreply, new_state}
  end

  defp find_cell!(cells, cell_name) do
    # cursed :D
    with :error <- Map.fetch(cells.input, cell_name),
         :error <- Map.fetch(cells.output, cell_name) do
      raise KeyError
    else
      {:ok, value} -> value
    end
  end

  defp find_cell_value!(cells, cell_name) do
    case find_cell!(cells, cell_name) do
      %{value: value} -> value
      value -> value
    end
  end

  defp compute_cell(cells, computable) do
    args = Enum.map(computable.deps, &find_cell_value!(cells, &1))
    new_value = apply(computable.fun, args)

    if new_value != computable.value do
      Enum.each(computable.callbacks, fn {name, cb} -> cb.(name, new_value) end)
      update_in(cells, [:output, computable.name, :value], fn _ -> new_value end)
    else
      cells
    end
  end
end
