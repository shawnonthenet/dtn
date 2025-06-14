defmodule DtnWeb.PageController do
  use DtnWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
