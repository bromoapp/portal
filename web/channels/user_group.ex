defmodule Portal.UserGroup do
    use Portal.Web, :channel
    alias Ecto.Adapters.SQL
    alias Mariaex.Result
    alias Portal.GroupPresence
    alias Portal.GroupUpdates
    alias Portal.Group
    alias Portal.User
    require Logger

    # Event topics
    @p2g_msg_out "p2g_msg_out"
    @p2g_msg_new "p2g_msg_new"
    @p2g_msg_in "p2g_msg_in"
    @query_chats "query_chats"

    # SQLs
    @sql_ongoing_gchats "CALL `sp_ongoing_gchats`(?);"

    #=================================================================================================
    # Functions related to members connections and presences
    #=================================================================================================
    def join("user_group:" <> unique, _params, socket) do
        send self(), :after_join

        {_socket, updates} = {socket, %GroupUpdates{}}
        |> _get_admins_list()
        |> _get_members_list()
        |> _get_ongoing_chats()
        {:ok, updates, socket}
    end

    def terminate(_reason, socket) do
        user = socket.assigns.user
        GroupPresence.untrack(socket, user.username)
        {:noreply, socket}
    end

    def handle_info(:after_join, socket) do
        user = socket.assigns.user
        GroupPresence.track(socket, user.username, %{name: user.name, username: user.username})
        {:noreply, socket}
    end

    defp _get_admins_list({socket, struct}) do
        unique = _parse_unique(socket.topic)
        group = Repo.get_by(Group, unique: unique)
        if (group != nil) do
            admins = _parse_users(String.split(group.admins, ","))
            |> Enum.map(fn(x) -> %{name: x.name, username: x.username} end)
            {socket, %GroupUpdates{struct | admins: admins}}
        else
            {socket, %GroupUpdates{struct | admins: []}}
        end
    end

    defp _get_members_list({socket, struct}) do
        unique = _parse_unique(socket.topic)
        user = socket.assigns.user
        group = Repo.get_by(Group, unique: unique)
        if (group != nil) do
            members = _parse_users(String.split(group.members, ","))
            |> Enum.map(fn(x) -> %{name: x.name, username: x.username} end)
            {socket, %GroupUpdates{struct | members: members}}
        else
            {socket, %GroupUpdates{struct | members: []}}
        end
    end

    defp _get_ongoing_chats({socket, struct}) do
        user = socket.assigns.user
        %Result{rows: rows} = SQL.query!(Repo, @sql_ongoing_gchats, [user.id])
        if rows == [] do
            {socket, %GroupUpdates{struct | chats: []}}
        else
            {socket, %GroupUpdates{struct | chats: _parse_gchats(rows, [])}}
        end
    end

    defp _parse_gchats([], result) do
        result
    end

    defp _parse_gchats([h|t], result) do
        [counter_id, id, read, type] = h
        nresult = result ++ [%{id: id, counter_id: counter_id, chats: nil, date: nil, read: read, type: type}]
        _parse_gchats(t, nresult)
    end

    #=================================================================================================
    # Functions related to p2p chats
    #=================================================================================================
    def handle_in(@query_chats, %{"id" => id}, socket) do
        Logger.info(">>> RECEIVED GROUP QUERY CHATS WITH CHAT ID = #{inspect id}")
        json = %{id: nil, counter_id: nil, date: nil, chats: nil, read: 1, type: nil}
        {:reply, {:ok, %{"query_chats_resp" => json}}, socket}
    end
    
    #=================================================================================================
    # Helper functions
    #=================================================================================================
    defp _parse_unique(topic) do
        [_h, unique] = String.split(topic, ":")
        unique
    end

    defp _parse_users(list) do
        Enum.map(list, fn(x) -> 
            id = Regex.replace(~r/#/, x, "")
            String.to_integer(id)
        end) |>
        Enum.map(fn(n) -> 
            user = Repo.get!(User, n)
            %{id: user.id, name: user.name, username: user.username}
        end)
    end
end