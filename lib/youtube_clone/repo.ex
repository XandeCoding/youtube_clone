defmodule YoutubeClone.Repo do
  use Ecto.Repo,
    otp_app: :youtube_clone,
    adapter: Ecto.Adapters.MyXQL
end
