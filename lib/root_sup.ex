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
  def init([:msg_call]) do
    children = [
      {Manager, [:msg_call]},
      {ChildSup, [:msg_call]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @impl true
  def init([:msg_cast]) do
    children = [
      {Manager, [:msg_cast]},
      {ChildSup, [:msg_cast]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
