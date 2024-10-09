defmodule MniscenceWeb.MniscenceLive do
  use MniscenceWeb, :live_view

  alias PrimerLive.Component, as: Primer

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :nodes, [])}
  end

  def handle_event("add-node", params, socket) do
    %{"node" => %{"cookie" => cookie, "name" => name}} = params

    # TODO add validation to the node form to ensure id is unique
    node = %{cookie: cookie, id: name, is_selected: false, name: name}
    {:noreply, stream_insert(socket, :nodes, node)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <Primer.box stream={@streams.nodes} id="node-row-slot" class="w-56">
        <:header class="d-flex flex-items-center">
          <Primer.button
            is_icon_only
            aria-label="Add Node"
            phx-click={Primer.open_dialog("add-node-dialog")}
          >
            <Primer.octicon name="plus-circle-16" />
          </Primer.button>
        </:header>
        <:header_title class="flex-auto">
          Nodes
        </:header_title>
        <:row
          :let={{_dom_id, node}}
          class="d-flex flex-items-center flex-justify-between"
          is_hover_blue
          is_blue={node[:is_selected]}
        >
          <span><%= node.name %></span>
        </:row>
      </Primer.box>
      <Primer.dialog
        id="add-node-dialog"
        is_backdrop
        focus_after_opening_selector="#node-name"
      >
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
    </div>
    """
  end
end
