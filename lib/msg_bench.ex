defmodule MsgBench do
  def run_msg_manager do
    MsgBench.RootSup.start_link([:msg_manager])
  end

  def send_msg() do
    MsgBench.Manager.send_message_to_childs()
  end
end
