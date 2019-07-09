defmodule MsgBench do
  def run_msg_manager(type) do
    MsgBench.RootSup.start_link([type])
  end

  def send_msg(type) do
    MsgBench.Manager.send_message_to_childs(type)
  end
end
