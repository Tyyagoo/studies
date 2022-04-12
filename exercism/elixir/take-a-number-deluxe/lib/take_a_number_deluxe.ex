defmodule TakeANumberDeluxe do
  use GenServer

  alias TakeANumberDeluxe.{State, Queue}
  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:next_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset)
  end

  # Server callbacks

  @impl GenServer
  def init(initial_arg) do
    with {:ok, min_number} <- Keyword.fetch(initial_arg, :min_number),
         {:ok, max_number} <- Keyword.fetch(initial_arg, :max_number),
         shutdown <- Keyword.get(initial_arg, :auto_shutdown_timeout, :infinity),
         {:ok, state} <- State.new(min_number, max_number, shutdown) do
      {:ok, state, shutdown}
    else
      _ -> {:stop, :invalid_configuration}
    end
  end

  @impl GenServer
  def handle_call(:report_state, _caller, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  def handle_call(:new_number, _caller, state) do
    case State.queue_new_number(state) do
      {:ok, number, new_state} -> {:reply, {:ok, number}, new_state, state.auto_shutdown_timeout}
      {:error, _reason} = err -> {:reply, err, state, state.auto_shutdown_timeout}
    end
  end

  def handle_call({:next_number, priority_number}, _caller, state) do
    case State.serve_next_queued_number(state, priority_number) do
      {:ok, number, new_state} -> {:reply, {:ok, number}, new_state, state.auto_shutdown_timeout}
      {:error, _reason} = err -> {:reply, err, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_cast(:reset, state) do
    {:noreply, %State{state | queue: Queue.new()}, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, _state) do
    exit(:normal)
  end

  def handle_info(_msg, state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end
end
