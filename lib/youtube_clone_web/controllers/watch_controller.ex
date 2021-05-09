defmodule YoutubeCloneWeb.WatchController do
  use YoutubeCloneWeb, :controller

  import YoutubeClone.Util
  alias YoutubeClone.VideoData

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    video = VideoData.get_video!(id)
    send_video(conn, headers, video)
  end

end

