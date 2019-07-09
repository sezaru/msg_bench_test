defmodule MsgBench.Manager do
  use GenServer

  def start_link([type]) do
    GenServer.start_link(__MODULE__, %{type: type, childs: %{}}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def subscribe(from_pid, name) do
    GenServer.call(__MODULE__, {:subscribe, from_pid, name})
  end

  @impl true
  def handle_call({:subscribe, from_pid, name}, _from, state) do
    state = state
    |> put_in([:childs, name], from_pid)

    IO.inspect(state)

    {:reply, :ok, state}
  end

  def send_message_to_childs() do
    GenServer.call(__MODULE__, :send_message_to_childs)
  end

  @impl true
  def handle_call(:send_message_to_childs, _from, state) do
    reply = state.childs
    |> Map.values()
    |> Enum.each(fn pid ->
      GenServer.call(pid, {:received_msg, "hello"})
    end)

    {:reply, reply, state}
  end
end
