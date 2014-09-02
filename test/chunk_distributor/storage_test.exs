defmodule ChunkDistributor.StorageTest do
  use ExUnit.Case
  require ChunkDistributor.Storage
  alias ChunkDistributor.Storage, as: Storage

  test "connects to cassandra" do
    {result, _} = Storage.cassandra_client
    assert result == :ok
  end

end
