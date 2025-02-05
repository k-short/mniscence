defmodule Mniscence.MnesiaTest do
  use ExUnit.Case, async: false
  alias Mniscence.Mnesia

  describe "list_tables/2" do
    setup do
      unless Node.alive?() do
        :net_kernel.start([:"ex_unit@127.0.0.1"])
      end

      test_node_name = :"test_node@127.0.0.1"
      test_cookie = :test_cookie

      {:ok, peer, node} =
        :peer.start(%{
          name: test_node_name
        })

      Node.set_cookie(node, test_cookie)

      on_exit(fn ->
        :peer.stop(peer)
        Node.stop()
      end)

      %{test_node: test_node_name, test_cookie: test_cookie}
    end

    @tag :skip
    # TODO: fix this test and add mnesia setup
    # I need to understand how to set up nodes/cookies better
    test "returns a list when an mnesia node is alive",
         %{test_node: node, test_cookie: cookie} do
      assert {:ok, _tables} = Mnesia.list_tables(node, cookie)
    end

    @moduletag :capture_log
    test "returns an error when node doesn't exist" do
      assert {:error, _error} =
               Mnesia.list_tables(:"nonexistent@127.0.0.1", :test_cookie)
    end

    @tag :skip
    # TODO: fix this test
    # I need to understand how to set up nodes/cookies better
    test "returns an error if the wrong cookie is used", %{test_node: node} do
      assert {:error, _error} = Mnesia.list_tables(node, :wrong_cookie)
    end
  end
end
