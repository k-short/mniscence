defmodule Mniscence.Mnesia do
  @moduledoc """
  A module for calling :mnesia functions from remote nodes.
  """

  require Logger

  @spec list_tables(atom(), atom()) :: {:ok, list(atom)} | {:error, atom()}
  def list_tables(node_name, node_cookie) do
    unless node_cookie == Node.get_cookie() do
      Node.set_cookie(Node.self(), node_cookie)
    end

    try do
      {:ok, :erpc.call(node_name, :mnesia, :system_info, [:tables])}
    rescue
      error ->
        Logger.error("Failed to call node #{node_name}: #{inspect(error)}")
        {:error, error}
    end
  end
end
