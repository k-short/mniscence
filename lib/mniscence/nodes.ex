defmodule Mniscence.Nodes do
  @moduledoc """
  A module for managing nodes.
  """

  require Logger

  @doc """
  Returns true if the node is alive, false otherwise.
  """
  @spec alive?(atom(), atom()) :: boolean()
  def alive?(name, cookie) when is_atom(name) and is_atom(cookie) do
    unless cookie == Node.get_cookie() do
      Node.set_cookie(Node.self(), cookie)
    end

    try do
      :erpc.call(name, :erlang, :is_alive, [])
    rescue
      error ->
        Logger.error("Failed to call node #{name}: #{inspect(error)}")
        false
    end
  end
end
