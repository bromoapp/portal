defmodule Portal.DkvServer do
    use GenServer

    alias Portal.Dkv

    require Logger

    def start_link(nodes \\ []) do
        GenServer.start_link(__MODULE__, nodes, name: {:global, __MODULE__})
    end

    def init(nodes) do
        case nodes do
            [] ->
                :ok = :lbm_kv.create(Dkv)
            _  ->
                Logger.info("Waiting to replicate data across nodes, starts at: #{inspect Timer.now}")
                :ok = :mnesia.wait_for_tables([Dkv], 60_000)
                :ok = :lbm_kv.create(Dkv)
                Logger.info("Data replications finished, ends at: #{inspect Timer.now}")
        end
        {:ok, []}
    end

    def insert(key, value) when is_atom(key) do
        pid = :global.whereis_name(__MODULE__)
        GenServer.call(pid, {:put, key, value})
    end

    def select(key) when is_atom(key) do
        pid = :global.whereis_name(__MODULE__)
        GenServer.call(pid, {:get, key})
    end

    def delete(key) when is_atom(key) do
        pid = :global.whereis_name(__MODULE__)
        GenServer.call(pid, {:del, key})
    end

    def update(key, value) when is_atom(key) do
        pid = :global.whereis_name(__MODULE__)
        GenServer.call(pid, {:upd, key, value})
    end

    def select_all() do
        pid = :global.whereis_name(__MODULE__)
        GenServer.call(pid, :all)
    end

    def handle_call({:put, key, value}, _from, args) do
        {:reply, :lbm_kv.put(Dkv, key, value), args}
    end

    def handle_call({:get, key}, _from, args) do
        {:reply, :lbm_kv.get(Dkv, key), args}
    end

    def handle_call({:del, key}, _from, args) do
        {:reply, :lbm_kv.del(Dkv, key), args}
    end

    def handle_call({:upd, key, value}, _from, args) do
        {:reply, :lbm_kv.update(Dkv, key, value), args}
    end

    def handle_call(:all, _from, args) do
        {:atomic, keys} = :mnesia.transaction fn -> :mnesia.all_keys(Dkv) end
        records = _select_all(keys, [])
        {:reply, records, args}
    end

    defp _select_all([], list) do
        list
    end

    defp _select_all([h|t], list) do
        {:ok, value} = :lbm_kv.get(Dkv, h)
        nlist = list ++ value
        _select_all(t, nlist)
    end

end