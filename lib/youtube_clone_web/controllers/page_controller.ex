defmodule YoutubeCloneWeb.PageController do
  use YoutubeCloneWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
