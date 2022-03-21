defmodule CircularBuffer do
  use GenServer

  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """
  @enforce_keys [:buffer, :capacity, :length]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          buffer: [any()],
          capacity: pos_integer(),
          length: non_neg_integer()
        }

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity), do: GenServer.start(__MODULE__, capacity)

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer), do: GenServer.call(buffer, :read)

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item), do: GenServer.call(buffer, {:write, item})

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item), do: GenServer.call(buffer, {:overwrite, item})

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer), do: GenServer.cast(buffer, :clear)

  @impl GenServer
  def init(capacity) do
    {:ok, %__MODULE__{buffer: [], capacity: capacity, length: 0}}
  end

  @impl GenServer
  def handle_call(:read, _, %__MODULE__{buffer: [], length: 0}) do
    {:reply, {:error, :empty}, []}
  end

  def handle_call(:read, _, %__MODULE__{buffer: buffer, capacity: cap, length: len}) do
    {item, new_buffer} = List.pop_at(buffer, -1)
    {:reply, {:ok, item}, %__MODULE__{buffer: new_buffer, capacity: cap, length: len - 1}}
  end

  def handle_call({:write, item}, _, state) do
    if state.length == state.capacity do
      {:reply, {:error, :full}, state}
    else
      {:reply, :ok, %__MODULE__{state | buffer: [item | state.buffer], length: state.length + 1}}
    end
  end

  def handle_call({:overwrite, item}, _, state) do
    new_buffer =
      if state.length == state.capacity do
        {_, lst} = List.pop_at(state.buffer, -1)
        [item | lst]
      else
        [item | state.buffer]
      end

    {:reply, :ok, %__MODULE__{state | buffer: new_buffer}}
  end

  @impl GenServer
  def handle_cast(:clear, %__MODULE__{capacity: capacity}) do
    {:noreply, %__MODULE__{buffer: [], capacity: capacity, length: 0}}
  end
end
