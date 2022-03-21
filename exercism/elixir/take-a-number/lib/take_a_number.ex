defmodule TakeANumber do
  def start() do
    spawn(fn -> loop(0) end)
  end

  defp loop(ticket_number) do
    receive do
      {:take_a_number, sender_pid} ->
        ticket_number + 1
        |> tap(fn t -> send(sender_pid, t) end)
        |> tap(&loop/1)
      {:report_state, sender_pid} ->
        ticket_number
        |> tap(fn t -> send(sender_pid, t) end)
        |> tap(&loop/1)
      :stop -> nil
      _ -> loop(ticket_number)
    end
  end
end
