defmodule YoutubeCloneWeb.VideoController do
  use YoutubeCloneWeb, :controller

  alias YoutubeClone.VideoData
  alias YoutubeClone.VideoData.Video

  import YoutubeClone.Util

  def index(conn, _params) do
    videos = VideoData.list_videos()
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params) do
    changeset = VideoData.change_video(%Video{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}) do
    changeset = Video.changeset(%Video{}, video_params)

    case VideoData.insert_video(changeset) do
      {:ok, video} ->
        persist_file(video, video_params["video_file"])

        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp persist_file(video, %{path: temp_path}) do
    video_path = build_video_path(video)
    unless File.exists?(video_path) do
      video_path |> Path.dirname() |> File.mkdir_p()
      File.cp!(temp_path, video_path)
      persist_backup_file(video, video_path)
    end
  end

  defp persist_backup_file(video, video_path) do
    backup_path = build_video_path(video, :disk2)
    video_path
    |> Path.dirname()
    |> File.mkdir_p()
    File.cp!(video_path, backup_path)
  end

  def show(conn, %{"id" => id}) do
    video = VideoData.get_video!(id)
    render(conn, "show.html", video: video)
  end
  
  def watch(%{req_headers: headers} = conn, %{"id" => id}) do
    video = VideoData.get_video!(id)
    send_video(conn, headers, video)
  end

  def edit(conn, %{"id" => id}) do
    video = VideoData.get_video!(id)
    changeset = VideoData.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
    video = VideoData.get_video!(id)

    case VideoData.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    video = VideoData.get_video!(id)
    {:ok, _video} = VideoData.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: Routes.video_path(conn, :index))
  end
end
