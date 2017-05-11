defmodule Portal.OnlineUsersDb do
    use GenServer
    import Process, only: [whereis: 1]
    alias Portal.OnlineUser
    alias Portal.OnlineUsersTb

    def run(node_addr) do
        Node.connect String.to_atom(node_addr)
    end

    def start_link(node_addr \\ nil) do
        GenServer.start_link(__MODULE__, node_addr, name: __MODULE__)
    end

    def init(node_addr) do
        case node_addr do
            nil ->
                :ok = :lbm_kv.create(OnlineUsersTb)
            _   ->
                timeout = 60_000
                worker = Task.async(__MODULE__, :run, [node_addr])
                Task.await(worker, timeout)
                case Node.list do
                    [] ->
                        :ok = :lbm_kv.create(OnlineUsersTb)
                    _  ->
                        :ok = :mnesia.wait_for_tables([OnlineUsersTb], timeout)
                        :ok = :lbm_kv.create(OnlineUsersTb)
                end
        end
        {:ok, []}
    end

    def insert(user) do
        this_pid = whereis(__MODULE__)
        %OnlineUser{username: username} = user
        GenServer.call(this_pid, {:put, String.to_atom(username), user})
    end

    def delete(username) do
        this_pid = whereis(__MODULE__)
        GenServer.call(this_pid, {:del, String.to_atom(username)})
    end

    def select(username) do
        this_pid = whereis(__MODULE__)
        GenServer.call(this_pid, {:get, String.to_atom(username)})
    end

    def update(user) do
        this_pid = whereis(__MODULE__)
        %OnlineUser{username: username} = user
        GenServer.call(this_pid, {:put, String.to_atom(username), user})
    end

    def handle_call({:put, key, value}, _from, args) do
        {:ok, _value} = :lbm_kv.put(OnlineUsersTb, key, value)
        {:reply, :ok, args}
    end
    
    def handle_call({:del, key}, _from, args) do
        {:ok, _value} = :lbm_kv.del(OnlineUsersTb, key)
        {:reply, :ok, args}
    end

    def handle_call({:get, key}, _from, args) do
        {:ok, value} = :lbm_kv.get(OnlineUsersTb, key)
        {:reply, value[key], args}
    end
    
end