defmodule ElixirDistributor do
  require Record
  Record.defrecord :stream, path: nil, bandwidth: nil, chunks: []

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
      "\n" -> do_extract_streams pid, playlists
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

  @doc """
  Extract chunks from stream playlists
  """
  def extract_chunks playlists do
    Enum.map playlists, &do_extract_chunks(&1)
  end

  defp do_extract_chunks(stream(path: path) = stream) do
    File.open! path, fn(pid) ->
      #TODO improve it
      IO.read(pid, :line)
      IO.read(pid, :line)
      IO.read(pid, :line)
      IO.read(pid, :line)

      chunks = do_extract_chunks(pid, [])
      stream(stream, chunks: chunks)
    end
  end

  defp do_extract_chunks(pid, chunks) do
    case IO.read(pid, :line) do
      "\n" -> do_extract_chunks(pid, chunks)
      :eof -> Enum.reverse chunks
      _extinf ->
        path = String.strip(IO.read(pid, :line))
        do_extract_chunks(pid, [path | chunks])
    end
  end

  def cassandra_client do
    :application.ensure_all_started(:cqerl)
    {:ok, client} = :cqerl.new_client({'127.0.0.1', 9042})
  end

end
