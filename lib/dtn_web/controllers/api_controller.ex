defmodule DtnWeb.ApiController do
  use DtnWeb, :controller

  def create_task(conn, %{"title" => title, "message" => message}) do
    {:ok, task} =
      Dtn.Tasks.create_task(%{
        "title" => title,
        "message" => message,
        "days" => "1",
        "type" => "task",
        "block" => "am"
      })

    text(conn, "OK")
  end
end
