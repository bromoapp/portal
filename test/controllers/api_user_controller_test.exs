defmodule Portal.ApiUserControllerTest do
    use Portal.ConnCase

    alias Portal.User

    @valid_input %{name: "my_name", password: "my_password"}

    setup do
        user = insert_user(@valid_input)
        conn = build_conn()
        |> put_req_header("accept", "application/json")
        {:ok, conn: conn, user: user}
    end

    test "Show method returns a valid user.json on query user by id", %{conn: conn, user: user} do
        conn = get(conn, api_user_path(conn, :show, user.id))
        assert json_response(conn, 200)["name"] == user.name
    end

    test "Update method returns a valid user.json on update user by id", %{conn: conn, user: user} do
        conn = put(conn, api_user_path(conn, :update, user.id), user: %{name: "John Doe", username: "johndoe"})
        assert json_response(conn, 200)["name"] == "John Doe"
        refute json_response(conn, 200)["name"] == user.name
    end
end