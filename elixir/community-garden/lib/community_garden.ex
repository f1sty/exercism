defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn -> {[], 1} end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, &elem(&1, 0))
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn {list, counter} ->
      plot = %Plot{plot_id: counter, registered_to: register_to}
      counter = counter + 1
      list = [plot | list]

      {plot, {list, counter}}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn {list, counter} ->
      {Enum.reject(list, &(&1.plot_id === plot_id)), counter}
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn {list, _counter} ->
      Enum.find(list, {:not_found, "plot is unregistered"}, &(&1.plot_id == plot_id))
    end)
  end
end
