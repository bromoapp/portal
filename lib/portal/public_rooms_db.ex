defmodule Portal.PublicRoomsDb do
    use GenServer
    import Process, only: [whereis: 1]
    alias Portal.PublicRoom
    alias Portal.PublicRoomsTb

    def run(node_addr) do
        Node.connect String.to_atom(node_addr)
    end

    def start_link(node_addr \\ nil) do
        GenServer.start_link(__MODULE__, node_addr, name: __MODULE__)
    end

    def init(node_addr) do
        case node_addr do
            nil ->
                :ok = :lbm_kv.create(PublicRoomsTb)
            _   ->
                timeout = 60_000
                worker = Task.async(__MODULE__, :run, [node_addr])
                Task.await(worker, timeout)
                case Node.list do
                    [] ->
                        :ok = :lbm_kv.create(PublicRoomsTb)
                    _  ->
                        :ok = :mnesia.wait_for_tables([PublicRoomsTb], timeout)
                        :ok = :lbm_kv.create(PublicRoomsTb)
                end
        end
        {:ok, []}
    end

end