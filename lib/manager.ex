defmodule MsgBench.Manager do
  use GenServer

  def start_link([type]) do
    GenServer.start_link(__MODULE__, %{type: type, childs: %{}}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  ## ONLY USED WHEN TYPE IS :registry

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

  ## ONLY USED WHEN TYPE IS :msg_call or :msg_cast
  def subscribe(from_pid, name) do
    GenServer.call(__MODULE__, {:subscribe, from_pid, name})
  end

  @impl true
  def handle_call({:subscribe, from_pid, name}, _from, state) do
    state = state
    |> put_in([:childs, name], from_pid)

    {:reply, :ok, state}
  end

  ## ONLY USED WHEN TYPE IS :msg_call
  def send_message_to_childs(:msg_call) do
    GenServer.call(__MODULE__, {:send_message_to_childs, :msg_call})
  end

  @impl true
  def handle_call({:send_message_to_childs, :msg_call}, _from, state) do
    reply = state.childs
    |> Map.values()
    |> Enum.each(fn pid ->
      GenServer.call(pid, {:received_msg, "hello"})
    end)

    {:reply, reply, state}
  end

  ## ONLY USED WHEN TYPE IS :msg_cast
  def send_message_to_childs(:msg_cast) do
    GenServer.call(__MODULE__, {:send_message_to_childs, :msg_cast})
  end

  @impl true
  def handle_call({:send_message_to_childs, :msg_cast}, _from, state) do
    state.childs
    |> Map.values()
    |> Enum.each(fn pid ->
      GenServer.cast(pid, {:received_msg, "hello"})
    end)

    {:reply, :ok, state}
  end
end
