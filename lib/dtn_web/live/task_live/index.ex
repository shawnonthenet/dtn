defmodule DtnWeb.TaskLive.Index do
  use DtnWeb, :live_view

  def mount(_params, _session, socket) do
    blank_tasks = %{"task" => [], "exercise" => [], "chore" => []}
    tasks = Dtn.Tasks.list_tasks!() |> Enum.group_by(& &1.type)
    tasks = Map.merge(blank_tasks, tasks)

    socket = assign(socket, :tasks, tasks)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
            <.link href={~p"/tasks/new"} class="btn btn-primary">New</.link>
    <div>
      <h1>Tasks</h1>
      <table class="table">
        <thead>
          <tr>
            <th>Title</th>
            <th>Message</th>
            <th>Days</th>
          </tr>
        </thead>
        <%= for task <- @tasks["task"] do %>
          <tr>
            <td><%= task.title %></td>
            <td><%= task.message %></td>
            <td><%= task.days %></td>
          </tr>
        <% end %>
      </table>
      <h1>Exercises</h1>
      <table class="table">
        <thead>
          <tr>
            <th>Title</th>
            <th>Message</th>
            <th>Days</th>
          </tr>
        </thead>
        <%= for task <- @tasks["exercise"] do %>
          <tr>
            <td><%= task.title %></td>
            <td><%= task.message %></td>
            <td><%= task.days %></td>
          </tr>
        <% end %>
      </table>
      <h1>Chores</h1>
      <table class="table">
        <thead>
          <tr>
            <th>Title</th>
            <th>Message</th>
            <th>Days</th>
          </tr>
        </thead>
        <%= for task <- @tasks["chore"] do %>
          <tr>
            <td><%= task.title %></td>
            <td><%= task.message %></td>
            <td><%= task.days %></td>
          </tr>
        <% end %>
      </table>
    </div>
    """
  end
end
