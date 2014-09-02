defmodule ElixirDistributorTest do
  use ExUnit.Case
  require ElixirDistributor

  test "extract streams from master playlist" do
    assert ElixirDistributor.extract_streams("test/fixtures/signal_example/") ==
      [ElixirDistributor.stream(bandwidth: "270336", path: "test/fixtures/signal_example/stream_264/playlist.m3u8", chunks: []),
        ElixirDistributor.stream(bandwidth: "475136", path: "test/fixtures/signal_example/stream_464/playlist.m3u8", chunks: [])]
  end

  test "extract chunk files from bitrate playlist" do
    assert ElixirDistributor.extract_chunks("test/fixtures/signal_example/stream_264/playlist.m3u8") == [
      "stream_1406047228241_1406047228241_876.ts",
      "stream_1406047228241_1406047228241_877.ts",
      "stream_1406047228241_1406047228241_878.ts",
      "stream_1406047228241_1406047228241_879.ts",
      "stream_1406047228241_1406047228241_880.ts",
      "stream_1406047228241_1406047228241_881.ts",
      "stream_1406047228241_1406047228241_882.ts",
      "stream_1406047228241_1406047228241_883.ts"
    ]
  end

end
