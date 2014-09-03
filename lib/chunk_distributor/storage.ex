defmodule ChunkDistributor.Storage do
  @type client :: {pid, reference}

  @spec cassandra_client :: {atom, client}
  def cassandra_client do
    :application.ensure_all_started(:cqerl)
    :cqerl.new_client({'127.0.0.1', 9042})
  end

end
