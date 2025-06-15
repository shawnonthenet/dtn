defmodule DtnWeb.TaskLive.Edit do
  use DtnWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    task = Dtn.Tasks.get_task!(id)
    form = Dtn.Tasks.form_to_update_task(task) |> to_form()
    {:ok, assign(socket, form: form)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>New Task</h1>
      <.form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:type]} type="select" options={[{"Chore", "chore"}, {"Exercise", "exercise"}, {"Task", "task"}]} label="Type" />
        <.input field={@form[:block]} type="select" options={[{"AM", "am"}, {"PM", "pm"}]} label="Block" />
        <.input field={@form[:title]} label="Title" />
        <.input field={@form[:message]} label="Message" />
        <.input field={@form[:days]} label="Days" />
        <.button>Create</.button>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"form" => form_data}, socket) do
    socket =
      update(socket, :form, fn form ->
        AshPhoenix.Form.validate(form, form_data)
      end)

    {:noreply, socket}
  end

  def handle_event("save", %{"form" => form_data}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_data) do
      {:ok, task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_navigate(to: ~p"/tasks")}

      {:error, form} ->
        {:noreply, socket |> assign(:form, form)}
    end
  end
end
