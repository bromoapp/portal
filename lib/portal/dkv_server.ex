defmodule Portal.DkvServer do
    use GenServer

    alias Portal.Dkv

    def start_link() do
        GenServer.start_link(__MODULE__, :ok, name: {:global, __MODULE__})
    end

    def init(args) do
        :lbm_kv.create(Dkv)
        {:ok, args}
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

    def handle_call({:put, key, value}, _from, args) do
        {:reply, :lbm_kv.put(Dkv, key, value), args}
    end

    def handle_call({:get, key}, _from, args) do
        {:reply, :lbm_kv.get(Dkv, key), args}
    end

    def handle_call({:del, key}, _from, args) do
        {:reply, :lbm_kv.del(Dkv, key), args}
    end

end