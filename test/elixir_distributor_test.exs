defmodule ElixirDistributorTest do
  use ExUnit.Case
  require ElixirDistributor

  test "extract bitrate playlists from master playlist" do
    assert ElixirDistributor.extract_bitrate_playlists("/test/fixtures/signal_example/playlist.m3u8") ==
      [ElixirDistributor.bitrate_playlist(bandwidth: 270336, path: "test/fixtures/signal_example/bitrate_264/playlist.m3u8"),
      ElixirDistributor.bitrate_playlist(bandwidth: 475136, path: "test/fixtures/signal_example/bitrate_464/playlist.m3u8")]
  end

end
