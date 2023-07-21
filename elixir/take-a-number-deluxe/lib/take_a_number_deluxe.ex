defmodule TakeANumberDeluxe do
  use GenServer
  alias TakeANumberDeluxe.State

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
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset_state)
  end

  @impl GenServer
  def init(init_arg) do
    auto_shutdown_timeout = Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)
    min_number = Keyword.get(init_arg, :min_number)
    max_number = Keyword.get(init_arg, :max_number)

    case State.new(min_number, max_number, auto_shutdown_timeout) do
      {:ok, state} -> {:ok, state, auto_shutdown_timeout}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl GenServer
  def handle_call(:report_state, _from, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    case State.queue_new_number(%State{auto_shutdown_timeout: auto_shutdown_timeout} = state) do
      {:ok, new_number, new_state} ->
        {:reply, {:ok, new_number}, new_state, auto_shutdown_timeout}

      {:error, _} = error ->
        {:reply, error, state, auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _from, state) do
    case State.serve_next_queued_number(
           %State{auto_shutdown_timeout: auto_shutdown_timeout} = state,
           priority_number
         ) do
      {:ok, next_number, new_state} ->
        {:reply, {:ok, next_number}, new_state, auto_shutdown_timeout}

      {:error, _} = error ->
        {:reply, error, state, auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_cast(:reset_state, %State{
        min_number: min_number,
        max_number: max_number,
        auto_shutdown_timeout: auto_shutdown_timeout
      }) do
        {:ok, state} = State.new(min_number, max_number, auto_shutdown_timeout)
    {:noreply, state, auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, _state) do
    {:noreply, Process.exit(self(), :normal)}
  end

  @impl GenServer
  def handle_info(_msg, state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end
end
