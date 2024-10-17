defmodule MniscenceWeb.MniscenceLive do
  use MniscenceWeb, :live_view

  alias PrimerLive.Component, as: Primer

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
      <Primer.dialog id="add-node-dialog" is_backdrop focus_after_opening_selector="#node-name">
        <:header_title>Add Node</:header_title>
        <:body>
          <.form autocomplete="off" phx-submit="add-node">
            <div style="display: flex; flex-direction: column; align-items: flex-start; gap: 1em;">
              <div style="width: 100%;">
                <Primer.text_input
                  form={:node}
                  field="name"
                  is_full_width
                  form_control={
                    %{
                      style: "width: 100%;"
                    }
                  }
                />
              </div>
              <div style="width: 100%;">
                <Primer.text_input
                  form={:node}
                  field="cookie"
                  is_full_width
                  form_control={
                    %{
                      style: "width: 100%;"
                    }
                  }
                />
              </div>
            </div>
            <div class="d-flex flex-justify-end mt-3">
              <Primer.button
                is_primary
                is_submit
                class="ml-2"
                phx-click={Primer.close_dialog("add-node-dialog")}
              >
                Add
              </Primer.button>
            </div>
          </.form>
        </:body>
      </Primer.dialog>
      <div id="vertical-split-panes" class="flex" phx-hook="Split">
        <div id="one" class="flex">LEFT PANE</div>
        <div id="two" class="flex">RIGHT PANE</div>
      </div>
    </div>
    """
  end
end
