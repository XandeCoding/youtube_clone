
defmodule YoutubeClone.FileService do

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

  def persist_file(video, %{path: temp_path}) do
    video_path = build_video_path(video)
    unless File.exists?(video_path) do
      video_path |> Path.dirname() |> File.mkdir_p()
      File.cp!(temp_path, video_path)
      persist_backup_file(video, video_path)
    end
  end

  def persist_backup_file(video, video_path) do
    backup_path = build_video_path(video, :disk2)
    video_path
    |> Path.dirname()
    |> File.mkdir_p()
    File.cp!(video_path, backup_path)
  end

end
