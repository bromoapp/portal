defmodule Portal.ApiChatController do
    use Portal.Web, :controller
    alias Ecto.Adapters.SQL
    alias Mariaex.Result
    require Logger

    plug :is_api_req_authorized?

    def latest(conn, %{"friend" => friend_uname}) do
        user = conn.assigns.current_user
        try do
            sql_1 = "SELECT a.id FROM users AS a WHERE a.username = ?"
            %Result{rows: ids} = SQL.query!(Repo, sql_1, [friend_uname])
            [[id]] = ids

            sql_2 = "CALL `sp_last_chats_with`(?, ?)"
            %Result{rows: chats} = SQL.query!(Repo, sql_2, [user.id, id])
            Logger.info(">>> FRIEND ID: #{inspect chats}")
            render(conn, "chats.json", chats: chats)
        rescue
            _error ->
                render(conn, "error.json", error: "record not found!")
        end
    end

    def ongoing(conn, %{"friend" => friend_uname, "date" => date}) do
        render(conn, "chats.json", nil)
    end
end