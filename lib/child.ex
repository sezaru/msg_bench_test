defmodule MsgBench.Child do
  use GenServer

  alias MsgBench.{Manager, Child}

  def start_link([type, id]) do
    name = String.to_atom("#{Child}.#{id}")
    
    GenServer.start_link(__MODULE__, %{type: type, name: name}, name: name)
  end

  ## ONLY USED WHEN TYPE IS :registry

  @impl true
  def init(state = %{type: :registry}) do
    {:ok, _} = Registry.register(:my_registry, :received_msg, [])
    
    {:ok, state}
  end

  @impl true
  def handle_info({:cast_event, :received_msg, msg}, state) do
    IO.inspect msg
    # Simulates some blocking work
    :timer.sleep(1_000)

    {:noreply, state}
  end

  ## ONLY USED WHEN TYPE IS :msg_manager
  
  @impl true
  def init(state = %{type: :msg_manager}) do
    Manager.subscribe(self(), state.name)
    
    {:ok, state}
  end

  @impl true
  def handle_call({:received_msg, _msg}, _from, state) do
    # Simulates some blocking work
    :timer.sleep(1_000)
    
    {:reply, :ok, state}
  end
end
