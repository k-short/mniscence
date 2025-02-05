defmodule MniscenceWeb.MniscenceLive do
  use MniscenceWeb, :live_view

  alias Mniscence.Mnesia

  @blank_node_form to_form(%{"name" => "", "cookie" => ""})

  def mount(_params, _session, socket) do
    test_node =
      %{
        connection_status: :disconnected,
        cookie: "asdf",
        id: "node-1",
        is_expanded: false,
        name: "nodeone@127.0.0.1",
        tables: []
      }

    {:ok,
     socket
     |> assign(:nodes, [test_node])
     |> assign(:show_add_node_modal, false)
     |> assign(:node_form, @blank_node_form)}
  end

  def handle_event("node-added", params, socket) do
    %{"cookie" => cookie, "name" => name} = params
    node_id = "node-#{1 + length(socket.assigns.nodes)}"

    node =
      %{
        connection_status: :disconnected,
        cookie: cookie,
        id: node_id,
        is_expanded: false,
        name: name,
        tables: []
      }

    {:noreply,
     socket
     |> update(:nodes, fn nodes -> Enum.sort_by([node | nodes], & &1.name) end)
     # TODO figure out why this isn't blanking the modal fields when it's opened again
     |> assign(:node_form, @blank_node_form)}
  end

  def handle_event("node-form-changed", _params, socket) do
    # TODO validation
    {:noreply, socket}
  end

  def handle_event("expand-node-toggled", %{"node-id" => node_id}, socket) do
    case Enum.find(socket.assigns.nodes, fn node -> node.id == node_id end) do
      %{is_expanded: true} = node ->
        handle_node_collapsed_event(node, socket)

      %{is_expanded: false} = node ->
        handle_node_expanded_event(node, socket)
    end
  end

  defp handle_node_expanded_event(expanded_node, socket) do
    update_node =
      fn node ->
        if node.id == expanded_node.id do
          {connection_status, is_expanded, tables} =
            case Mnesia.list_tables(String.to_atom(node.name), String.to_atom(node.cookie)) do
              {:ok, tables} -> {:connected, true, tables}
              {:error, _error} -> {:failed, false, []}
            end

          %{node | connection_status: connection_status, is_expanded: is_expanded, tables: tables}
        else
          node
        end
      end

    {:noreply, update(socket, :nodes, &Enum.map(&1, update_node))}
  end

  def handle_node_collapsed_event(collapsed_node, socket) do
    update_node =
      fn node ->
        if node.id == collapsed_node.id do
          %{node | connection_status: :disconnected, is_expanded: false}
        else
          node
        end
      end

    {:noreply, update(socket, :nodes, &Enum.map(&1, update_node))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.modal id="add-node-modal">
        <.simple_form for={@node_form} phx-change="node-form-changed" phx-submit="node-added">
          <.input field={@node_form[:name]} label="Name" />
          <.input field={@node_form[:cookie]} label="Cookie" />
          <:actions>
            <.button phx-click={hide_modal("add-node-modal")}>Add</.button>
          </:actions>
        </.simple_form>
      </.modal>
      <div>
        <div id="sidebar" class="flex flex-col w-1/4 min-h-96 p-2 border-solid border-2">
          <div class="flex justify-between">
            <div>Nodes</div>
            <button phx-click={show_modal("add-node-modal")}>
              <.icon name="hero-plus-circle" class="bg-green-500 hover:bg-green-400" />
            </button>
          </div>
          <hr class="my-2" />
          <div :for={node <- @nodes}>
            <div class="flex items-center">
              <button phx-click="expand-node-toggled" phx-value-node-id={node.id}>
                <.icon
                  name="hero-chevron-right"
                  class={if node.is_expanded, do: "w-3 h-3 mr-1 rotate-90", else: "w-3 h-3 mr-1"}
                />
              </button>
              <div>{node.name}</div>
              <%= case node.connection_status do %>
                <% :connected -> %>
                  <.icon name="hero-check" class="w-4 h-4 ml-3 bg-green-500" />
                <% :failed -> %>
                  <.icon name="hero-x-mark" class="w-4 h-4 ml-3 bg-red-500" />
                <% _ -> %>
              <% end %>
            </div>
            <%= if node.is_expanded do %>
              <div :for={table <- node.tables}>
                <div class="ml-5">{Atom.to_string(table)}</div>
              </div>
            <% else %>
              <div></div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
