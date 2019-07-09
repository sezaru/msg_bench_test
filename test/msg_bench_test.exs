defmodule MsgBenchTest do
  use ExUnit.Case
  doctest MsgBench

  test "greets the world" do
    assert MsgBench.hello() == :world
  end
end
