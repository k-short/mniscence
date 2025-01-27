defmodule Mniscence.NodesTest do
  use ExUnit.Case, async: false
  alias Mniscence.Nodes

  describe "alive?/2" do
    setup do
      unless Node.alive?() do
        :net_kernel.start([:"ex_unit@127.0.0.1"]) |> IO.inspect(label: "------- net_kernel.start ---------")
      end
      Node.self() |> IO.inspect(label: "------- Node.self ---------")

      test_node_name = :"test_node@127.0.0.1"
      test_cookie = :test_cookie
      {:ok, peer, node} = :peer.start(%{
        name: test_node_name,
      })
      Node.set_cookie(node, test_cookie)

      on_exit(fn ->
        :peer.stop(peer)
        Node.stop()
      end)

      %{test_node: test_node_name, test_cookie: test_cookie}
    end

    test "returns true when node is alive", %{test_node: node, test_cookie: cookie} do
      assert Nodes.alive?(node, cookie)
    end

    test "returns false when node doesn't exist" do
      assert false == Nodes.alive?(:"nonexistent@127.0.0.1", :test_cookie)
    end

    @tag :skip
    # TODO: fix this test
    # I need to understand how to set up nodes/cookies better
    test "returns false if the wrong cookie is used", %{test_node: node} do
      assert false == Nodes.alive?(node, :wrong_cookie)
    end
  end
end
