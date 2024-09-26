defmodule MniscenceWeb.MniscenceLive do
  use MniscenceWeb, :live_view

  alias PrimerLive.Component, as: Primer

  def mount(_params, _session, socket) do
    test_nodes =
      [
        %{id: "node-1", name: "Node 1"},
        %{id: "node-2", name: "Node 2"},
        %{id: "node-3", name: "Node 3"}
      ]

    {:ok, stream(socket, :nodes, test_nodes)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <Primer.box stream={@streams.nodes} id="node-row-slot" class="w-56">
        <:header class="d-flex flex-items-center">
          <Primer.button is_icon_only aria-label="Add Connection">
            <Primer.octicon name="plus-circle-16" />
          </Primer.button>
        </:header>
        <:header_title class="flex-auto">
          Nodes
        </:header_title>
        <:row :let={{_dom_id, node}} class="d-flex flex-items-center flex-justify-between">
          <span><%= node.name %></span>
        </:row>
      </Primer.box>
    </div>
    """
  end
end
