defmodule MsgBench.Manager do
  use GenServer

  def start_link([type]) do
    GenServer.start_link(__MODULE__, %{type: type, childs: %{}}, name: __MODULE__)
  end

  ## ONLY USED WHEN TYPE IS :registry

  @impl true
  def init(state = %{type: :registry}) do
    {:ok, state}
  end

  def send_message_to_childs(:registry) do
    GenServer.call(__MODULE__, {:send_message_to_childs, :registry})
  end

  @impl true
  def handle_call({:send_message_to_childs, :registry}, _from, state) do
    reply = Registry.dispatch(:my_registry, :received_msg, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:cast_event, :received_msg, "hello"})
    end)

    {:reply, reply, state}
  end

  ## ONLY USED WHEN TYPE IS :msg_manager
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

    {:reply, :ok, state}
  end

  def send_message_to_childs(:msg_manager) do
    GenServer.call(__MODULE__, {:send_message_to_childs, :msg_manager})
  end

  @impl true
  def handle_call({:send_message_to_childs, :msg_manager}, _from, state) do
    reply = state.childs
    |> Map.values()
    |> Enum.each(fn pid ->
      GenServer.call(pid, {:received_msg, "hello"})
    end)

    {:reply, reply, state}
  end
end
