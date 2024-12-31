defmodule MniscenceWeb.MniscenceLive do
  use MniscenceWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :nodes, [])}
  end

  def handle_event("add-node", params, socket) do
    %{"node" => %{"cookie" => cookie, "name" => name}} = params

    # TODO use a unique ID
    node = %{cookie: cookie, id: name, is_selected: false, name: name}
    {:noreply, update(socket, :nodes, fn nodes -> [node | nodes] end)}
  end

  def handle_event("node-selected", params, socket) do
    %{"node-id" => selected_node_id} = params

    update_is_selected =
      fn node -> %{node | is_selected: node.id == selected_node_id} end

    {:noreply, update(socket, :nodes, &Enum.map(&1, update_is_selected))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div id="vertical-split-panes" phx-hook="Split">
        <div id="left-pane" class="split">LEFT PANE</div>
        <div id="right-pane" class="split">RIGHT PANE</div>
      </div>
    </div>
    """
  end
end
