defmodule Portal.ApiUserControllerTest do
    use Portal.ConnCase
    
    @moduledoc """
    This is an integration test for Portal.ApiUserController
    """

    @user %{name: "my_name", username: "my_username", password: "my_password"}
    @user_updates %{name: "John Doe", username: "johndoe"}

    setup do
        user = insert_user(@user)
        conn = build_conn()
            |> put_req_header("accept", "application/json")
            |> assign(:current_user, user)
        {:ok, conn: conn, user: user}
    end

    test "Show method returns a valid user.json on query user by id", %{conn: conn, user: user} do
        conn = get(conn, api_user_path(conn, :show, user.id))
        assert json_response(conn, 200)["name"] == user.name
    end

    test "Show method returns an error on querying non existence user", %{conn: conn} do
        conn = get(conn, api_user_path(conn, :show, "10101"))
        assert json_response(conn, 200)["error"] == "record not found!"
    end

    test "Update method returns a valid user.json on update user by id", %{conn: conn, user: user} do
        conn = put(conn, api_user_path(conn, :update, user.id), user: @user_updates)
        assert json_response(conn, 200)["name"] == "John Doe"
        refute json_response(conn, 200)["name"] == user.name
    end

    test "Update method returns an error on updating non existence user", %{conn: conn} do
        conn = put(conn, api_user_path(conn, :update, "2000"), user: @user_updates)
        assert json_response(conn, 200)["error"] == "record not found!"
    end

end