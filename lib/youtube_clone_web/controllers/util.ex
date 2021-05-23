
defmodule YoutubeClone.Util do

  def build_video_path(video) do
    Application.get_env(:youtube_clone, :disk1)
    |> Path.join(video.path)
  end

  def build_video_path(video, disk) do
    Application.get_env(:youtube_clone, disk)
    |> Path.join(video.path)
  end

  def get_offset(headers) do
    case List.keyfind(headers, "range", 0) do
      {"range", "bytes=" <> start_pos} ->
        String.split(start_pos, "-")
        |> hd
        |> String.to_integer
      nil ->
        0
    end
  end

  def get_file_size(path) do
    {:ok, %{size: size}} = File.stat path

    size
  end

  def get_video_path(video) do
    primary_path = build_video_path(video)

    if File.exists?(primary_path) do
      primary_path
    else
      build_video_path(video, :disk2)
    end
  end


  def send_video(conn, headers, video) do
    video_path = get_video_path(video)
    IO.inspect(video_path)
    offset = get_offset(headers)
    file_size = get_file_size(video_path)

    conn
    |> Plug.Conn.put_resp_header("content-type", video.content_type)
    |> Plug.Conn.put_resp_header("content-range", "bytes #{offset}-#{file_size-1}/#{file_size}")
    |> Plug.Conn.send_file(206, video_path, offset, file_size - offset)
  end

end
