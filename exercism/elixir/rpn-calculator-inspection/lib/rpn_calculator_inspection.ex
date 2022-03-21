defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    spawn_link(fn -> calculator.(input) end)
    |> (fn pid -> %{input: input, pid: pid} end).()
  end

  @spec await_reliability_check_result(%{:input => any, :pid => any, optional(any) => any}, any) ::
          map
  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> :ok
      {:EXIT, ^pid, _} -> :error
    after
      100 -> :timeout
    end
    |> (fn status -> Map.put(results, input, status) end).()
  end

  def reliability_check(calculator, inputs) do
    original_flag = Process.flag(:trap_exit, true)

    inputs
    |> Enum.map(&start_reliability_check(calculator, &1))
    |> Enum.map(&await_reliability_check_result(&1, %{}))
    |> Enum.reduce(%{}, &Map.merge/2)
    |> Kernel.tap(fn _ -> Process.flag(:trap_exit, original_flag) end)
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Enum.map(&Task.await(&1, 100))
  end
end
