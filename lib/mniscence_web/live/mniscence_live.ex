defmodule MniscenceWeb.MniscenceLive do
  use MniscenceWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:nodes, [])
      |> assign(:show_add_node_modal, false)
      |> assign(:node_form, to_form(%{"name" => "", "cookie" => ""}))
    }

  end

  def handle_event("add-node", params, socket) do
    %{"cookie" => cookie, "name" => name} = params

    # TODO use a unique ID
    node = %{cookie: cookie, id: name, is_selected: false, name: name}
    {:noreply, update(socket, :nodes, fn nodes -> [node | nodes] end)}
  end

  def handle_event("validate-node-form", _params, socket) do
    # TODO validation
    {:noreply, socket}
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
      <.modal id="add-node-modal">
        <.simple_form for={@node_form} phx-change="validate-node-form" phx-submit="add-node">
          <.input field={@node_form[:name]} label="Name"/>
          <.input field={@node_form[:cookie]} label="Cookie" />
          <:actions>
            <.button phx-click={hide_modal("add-node-modal")}>Add</.button>
          </:actions>
        </.simple_form>
      </.modal>
      <div id="vertical-split-panes" phx-hook="Split">
        <div id="left-pane" class="split">
          <div
            id="sidebar"
            class="flex flex-col"
          >
            <div class="flex justify-between">
              <div>Nodes</div>
              <button phx-click={show_modal("add-node-modal")}>
                <.icon
                  name="hero-plus-circle"
                  class="bg-green-500 hover:bg-green-400"
                />
              </button>
            </div>
            <hr />
            <%= if Enum.empty?(@nodes) do %>
              <div>No nodes added</div>
            <% else %>
              <div :for={node <- @nodes}>
                <div>{node.name}</div>
              </div>
            <% end %>
          </div>
        </div>
        <div id="right-pane" class="split"></div>
      </div>
    </div>
    """
  end
end
