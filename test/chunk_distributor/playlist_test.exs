defmodule ChunkDistributor.PlaylistTest do
  use ExUnit.Case
  require ChunkDistributor.Playlist
  alias ChunkDistributor.Playlist, as: Playlist

  @stream_264 Playlist.stream(bandwidth: "270336", path: "test/fixtures/signal_example/stream_264/playlist.m3u8", chunks: [])
  @stream_464 Playlist.stream(bandwidth: "475136", path: "test/fixtures/signal_example/stream_464/playlist.m3u8", chunks: [])


  test "extracts streams from master playlist" do
    assert Playlist.extract_streams("test/fixtures/signal_example/") ==
      [@stream_264, @stream_464]
  end

  @expected_chunks [
    "stream_1406047228241_1406047228241_876.ts",
    "stream_1406047228241_1406047228241_877.ts",
    "stream_1406047228241_1406047228241_878.ts",
    "stream_1406047228241_1406047228241_879.ts",
    "stream_1406047228241_1406047228241_880.ts",
    "stream_1406047228241_1406047228241_881.ts",
    "stream_1406047228241_1406047228241_882.ts",
    "stream_1406047228241_1406047228241_883.ts"
  ]

  test "extracts chunk files from bitrate playlist" do
    stream = [@stream_264] 
              |> Playlist.extract_chunks
              |> List.first

    assert Playlist.stream(stream, :chunks) == @expected_chunks
    assert Playlist.stream(stream, :bandwidth) == "270336"
  end

end
