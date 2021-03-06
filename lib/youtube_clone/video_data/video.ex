defmodule YoutubeClone.VideoData.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :content_type, :string
    field :description, :string
    field :filename, :string
    field :path, :string
    field :title, :string
    field :video_file, :any, virtual: true

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:title, :description, :filename, :content_type, :path, :video_file])
    |> validate_required([:title, :description])
    |> put_video_file()
  end

  def put_video_file(changeset) do
    IO.inspect(changeset)
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{video_file: video_file}} ->
        path = Ecto.UUID.generate() <> Path.extname(video_file.filename)
        changeset
        |> put_change(:path, path)
        |> put_change(:filename, video_file.filename)
        |> put_change(:content_type, video_file.content_type)
      _ ->       
        changeset
    end
  end

end
