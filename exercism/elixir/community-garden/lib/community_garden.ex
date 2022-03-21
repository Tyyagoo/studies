# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []), do: Agent.start(fn -> %{id: 1, content: []} end, opts)

  def list_registrations(pid), do: pid |> Agent.get(fn %{content: c} -> c end)

  def register(pid, register_to) do
    pid
    |> Agent.get(fn %{id: id} ->
      %Plot{plot_id: id, registered_to: register_to}
    end)
    |> (fn plot ->
          Agent.update(pid, fn %{id: id, content: c} -> %{id: id + 1, content: [plot | c]} end)
          plot
        end).()
  end

  def release(pid, plot_id) do
    pid
    |> Agent.update(fn %{id: id, content: c} ->
      %{id: id, content: do_release(c, plot_id)}
    end)
  end

  defp do_release(plot_list, plot_id) do
    plot_list
    |> Enum.filter(fn %Plot{plot_id: id} -> plot_id != id end)
  end

  def get_registration(pid, plot_id) do
    pid
    |> list_registrations()
    |> Enum.find({:not_found, "plot is unregistered"}, fn plot -> plot.plot_id == plot_id end)
  end
end
