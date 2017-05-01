defmodule Portal.OnlineUsersServer do
    use GenServer

    import Process, only: [whereis: 1]
    alias Portal.OnlineUsers

    require Logger

    def start_link(nodes \\ []) do
        GenServer.start_link(__MODULE__, nodes, name: __MODULE__)
    end

    def init(nodes) do
        case nodes do
            [] ->
                :ok = :lbm_kv.create(OnlineUsers)
            _  ->
                Logger.info("Waiting to replicate data across nodes, starts at: #{inspect Timer.now}")
                :ok = :mnesia.wait_for_tables([OnlineUsers], 60_000)
                :ok = :lbm_kv.create(OnlineUsers)
                Logger.info("Data replications finished, ends at: #{inspect Timer.now}")
        end
        {:ok, []}
    end

    def reg_user(key, value) when is_atom(key) do
        pid = whereis(__MODULE__)
        GenServer.call(pid, {:put, key, value})
    end

    def get_user(key) when is_atom(key) do
        pid = whereis(__MODULE__)
        GenServer.call(pid, {:get, key})
    end

    def unreg_user(key) when is_atom(key) do
        pid = whereis(__MODULE__)
        GenServer.call(pid, {:del, key})
    end

    def upd_user(key, value) when is_atom(key) do
        pid = whereis(__MODULE__)
        GenServer.call(pid, {:upd, key, value})
    end

    def get_users() do
        pid = whereis(__MODULE__)
        GenServer.call(pid, :all)
    end

    def handle_call({:put, key, value}, _from, args) do
        {:ok, value} = :lbm_kv.put(OnlineUsers, key, value)
        {:reply, value, args}
    end

    def handle_call({:get, key}, _from, args) do
        {:ok, value} = :lbm_kv.get(OnlineUsers, key)
        {:reply, value, args}
    end

    def handle_call({:del, key}, _from, args) do
        {:ok, value} = :lbm_kv.del(OnlineUsers, key)
        {:reply, value, args}
    end

    def handle_call({:upd, key, value}, _from, args) do
        {:ok, value} = :lbm_kv.update(OnlineUsers, key, value)
        {:reply, value, args}
    end

    def handle_call(:all, _from, args) do
        {:atomic, keys} = :mnesia.transaction fn -> :mnesia.all_keys(OnlineUsers) end
        records = _select_all(keys, [])
        {:reply, records, args}
    end

    defp _select_all([], list) do
        list
    end

    defp _select_all([h|t], list) do
        {:ok, value} = :lbm_kv.get(OnlineUsers, h)
        nlist = list ++ value
        _select_all(t, nlist)
    end

end