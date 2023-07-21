defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    pid = spawn_link(fn -> calculator.(input) end)

    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    status =
      receive do
        {:EXIT, ^pid, :normal} -> :ok
        {:EXIT, ^pid, _reason} -> :error
      after
        100 -> :timeout
      end

    Map.put(results, input, status)
  end

  def reliability_check(calculator, inputs) do
    old_value = Process.flag(:trap_exit, true)

    return =
      inputs
      |> Enum.map(&start_reliability_check(calculator, &1))
      |> Enum.reduce(%{}, &await_reliability_check_result/2)

    Process.flag(:trap_exit, old_value)

    return
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Enum.map(&Task.await(&1, 100))
  end
end
