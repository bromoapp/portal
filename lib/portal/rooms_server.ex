defmodule Portal.RoomsServer do
    use GenServer

    import Process, only: [whereis: 1]
    alias Portal.Rooms

    @join_node_timeout 60_000

    def start_link(node_addr \\ nil) do
        GenServer.start_link(__MODULE__, node_addr, name: __MODULE__)
    end

    def init(node_addr) do
        case node_addr do
            nil ->
                :ok = :lbm_kv.create(Rooms)
            _  ->
                worker = Task.async(__MODULE__, :run, [node_addr])
                Task.await(worker, @join_node_timeout)
                case Node.list do
                    [] ->
                        :ok = :lbm_kv.create(Rooms)
                    _  ->
                        :ok = :mnesia.wait_for_tables([Rooms], 60_000)
                        :ok = :lbm_kv.create(Rooms)
                end
        end
        {:ok, []}
    end

    def run(addr) do
        Node.connect String.to_atom(addr)
    end

    def reg_room(key, value) when is_atom(key) do
        pid = whereis(__MODULE__)
        GenServer.call(pid, {:put, key, value})
    end

    def get_room(key) when is_atom(key) do
        pid = whereis(__MODULE__)
        GenServer.call(pid, {:get, key})
    end

    def unreg_room(key) when is_atom(key) do
        pid = whereis(__MODULE__)
        GenServer.call(pid, {:del, key})
    end

    def upd_room(key, value) when is_atom(key) do
        pid = whereis(__MODULE__)
        GenServer.call(pid, {:upd, key, value})
    end

    def get_rooms() do
        pid = whereis(__MODULE__)
        GenServer.call(pid, :all)
    end

    def handle_call({:put, key, value}, _from, args) do
        {:ok, value} = :lbm_kv.put(Rooms, key, value)
        {:reply, value, args}
    end

    def handle_call({:get, key}, _from, args) do
        {:ok, value} = :lbm_kv.get(Rooms, key)
        {:reply, value, args}
    end

    def handle_call({:del, key}, _from, args) do
        {:ok, value} = :lbm_kv.del(Rooms, key)
        {:reply, value, args}
    end

    def handle_call({:upd, key, value}, _from, args) do
        {:ok, value} = :lbm_kv.update(Rooms, key, value)
        {:reply, value, args}
    end

    def handle_call(:all, _from, args) do
        {:atomic, keys} = :mnesia.transaction fn -> :mnesia.all_keys(Rooms) end
        records = _select_all(keys, [])
        {:reply, records, args}
    end

    defp _select_all([], list) do
        list
    end

    defp _select_all([h|t], list) do
        {:ok, value} = :lbm_kv.get(Rooms, h)
        nlist = list ++ value
        _select_all(t, nlist)
    end

end