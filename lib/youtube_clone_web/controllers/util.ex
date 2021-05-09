
defmodule YoutubeClone.Util do

  def build_video_path(video) do
    Application.get_env(:youtube_clone, :uploads_dir) |> Path.join(video.path)
  end

end
