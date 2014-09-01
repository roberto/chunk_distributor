defmodule ElixirDistributor do
  require Record
  Record.defrecord :bitrate_playlist, bandwidth: nil, path: nil

  def extract_bitrate_playlists path do
    [bitrate_playlist(bandwidth: 123, path: '123')]
  end
end
