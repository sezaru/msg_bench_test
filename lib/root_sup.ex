defmodule MsgBench.RootSup do
  use Supervisor

  alias MsgBench.{Manager, ChildSup}

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init([type]) do
    children = [
      {Manager, [type]},
      {ChildSup, [type]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
