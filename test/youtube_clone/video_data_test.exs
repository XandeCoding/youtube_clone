defmodule YoutubeClone.VideoDataTest do
  use YoutubeClone.DataCase

  alias YoutubeClone.VideoData

  describe "videos" do
    alias YoutubeClone.VideoData.Video

    @valid_attrs %{content_type: "some content_type", description: "some description", filename: "some filename", path: "some path", title: "some title"}
    @update_attrs %{content_type: "some updated content_type", description: "some updated description", filename: "some updated filename", path: "some updated path", title: "some updated title"}
    @invalid_attrs %{content_type: nil, description: nil, filename: nil, path: nil, title: nil}

    def video_fixture(attrs \\ %{}) do
      {:ok, video} =
        attrs
        |> Enum.into(@valid_attrs)
        |> VideoData.create_video()

      video
    end

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert VideoData.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert VideoData.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      assert {:ok, %Video{} = video} = VideoData.create_video(@valid_attrs)
      assert video.content_type == "some content_type"
      assert video.description == "some description"
      assert video.filename == "some filename"
      assert video.path == "some path"
      assert video.title == "some title"
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = VideoData.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      assert {:ok, %Video{} = video} = VideoData.update_video(video, @update_attrs)
      assert video.content_type == "some updated content_type"
      assert video.description == "some updated description"
      assert video.filename == "some updated filename"
      assert video.path == "some updated path"
      assert video.title == "some updated title"
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = VideoData.update_video(video, @invalid_attrs)
      assert video == VideoData.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = VideoData.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> VideoData.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = VideoData.change_video(video)
    end
  end
end
