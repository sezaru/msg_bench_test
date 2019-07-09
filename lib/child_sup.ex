defmodule MsgBench.ChildSup do
  use Supervisor

  alias MsgBench.Child

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init([type]) do
    children = 1..100
    |> Enum.map(fn id ->
      Supervisor.child_spec({Child, [type, id]}, id: String.to_atom("#{Child}.#{id}"))
    end)

    Supervisor.init(children, strategy: :one_for_one)
  end
end
