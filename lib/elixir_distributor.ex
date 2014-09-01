defmodule ElixirDistributor do
  require Record
  Record.defrecord :bitrate_playlist, bandwidth: nil, path: nil

  def extract_bitrate_playlists base_path do
    playlist_path = Path.join base_path, "playlist.m3u8"

    File.open! playlist_path, fn(pid) ->
      # Discards #EXTM3U
      IO.read(pid, :line)
      do_extract_bitrate_playlists(pid, [])
    end
  end

  defp do_extract_bitrate_playlists(pid, acc) do
    case IO.read(pid, :line) do
      :eof -> acc
      stream_inf ->
        path = IO.read(pid, :line)
        do_extract_bitrate_playlists(pid, stream_inf, path, acc)
    end
  end

  defp do_extract_bitrate_playlists(pid, stream_inf, path, acc)  do
    << "#EXT-X-STREAM-INF:PROGRAM-ID=", _program_id, ",BANDWIDTH=", bandwidth :: binary >> = stream_inf
    record = bitrate_playlist(path: String.strip(path), bandwidth: String.strip(bandwidth))
    do_extract_bitrate_playlists(pid, [record|acc])
  end

end
