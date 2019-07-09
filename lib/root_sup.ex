defmodule MsgBench.RootSup do
  use Supervisor

  alias MsgBench.{Manager, ChildSup}

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init([:registry]) do
    children = [
      {Registry, [keys: :duplicate, name: :my_registry, partitions: System.schedulers_online()]},
      {Manager, [:registry]},
      {ChildSup, [:registry]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @impl true
  def init([:msg_manager]) do
    children = [
      {Manager, [:msg_manager]},
      {ChildSup, [:msg_manager]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
