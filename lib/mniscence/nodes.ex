defmodule Mniscence.Nodes do
  @moduledoc """
  A module for managing nodes.
  """

  def alive?(name, cookie) when is_atom(name) and is_atom(cookie) do
    # This does not work because the self node is not a distributed node
    Node.set_cookie(cookie)

    # Currently failing
    :erpc.call(name, :is_alive)
  end
end
