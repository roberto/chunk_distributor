defmodule ChunkDistributor.Storage do

  def cassandra_client do
    :application.ensure_all_started(:cqerl)
    {:ok, _client} = :cqerl.new_client({'127.0.0.1', 9042})
  end

end
