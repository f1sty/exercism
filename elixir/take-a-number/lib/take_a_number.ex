defmodule TakeANumber do
  def start() do
    Process.spawn(__MODULE__, :numbers, [0], [])
  end

  @doc false
  def numbers(state) do
    receive do
      {:report_state, pid} ->
        send(pid, state)
        numbers(state)

      {:take_a_number, pid} ->
        state = state + 1
        send(pid, state)
        numbers(state)

      :stop ->
        :stoped

      _msg ->
        numbers(state)
    end
  end
end
