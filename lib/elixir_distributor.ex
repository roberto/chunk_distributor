defmodule ElixirDistributor do
  require Record
  Record.defrecord :stream, bandwidth: nil, path: nil, chunks: []

  @doc """
  Extract stream playlists
  """
  def extract_streams basepath do
    playlist_path = Path.join basepath, "playlist.m3u8"

    File.open! playlist_path, fn(pid) ->
      # Discards #EXTM3U
      IO.read(pid, :line)
      Enum.map do_extract_streams(pid, []), fn(playlist) ->
        stream(playlist, path: Path.join(basepath, stream(playlist, :path)))
      end
    end
  end

  defp do_extract_streams pid, playlists do
    case IO.read(pid, :line) do
      :eof -> playlists
      stream_inf ->
        path = IO.read(pid, :line)
        do_extract_streams pid, stream_inf, path, playlists
    end
  end

  defp do_extract_streams pid, stream_inf, path, playlists  do
    << "#EXT-X-STREAM-INF:PROGRAM-ID=", _program_id, ",BANDWIDTH=", bandwidth :: binary >> = stream_inf
    record = stream(path: String.strip(path), bandwidth: String.strip(bandwidth))
    do_extract_streams pid, [record|playlists]
  end

  def extract_chunks bitrate_playlist do
    []
  end

end
