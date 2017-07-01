defmodule Portal.ApiUserControllerTest do
    use Portal.ConnCase
    
    @moduledoc """
    This is an integration test for Portal.ApiUserController
    """

    @user %{name: "my_name", username: "my_username", password: "my_password"}
    @user_updates %{name: "John Doe", username: "johndoe"}
    @credential %{"session" => %{"username" => @user.username, "password" => @user.password}}

    setup do
        user = insert_user(@user)
        conn = build_conn()

        {:ok, conn: conn, user: user}
    end

    test "1. Show method returns a valid user.json on query user by id", %{conn: conn, user: user} do
        conn = post(conn, session_path(conn, :create), @credential)
        assert redirected_to(conn) == page_path(conn, :lobby)

        conn = get(conn, api_user_path(conn, :show))
        assert json_response(conn, 200)["name"] == user.name
    end

    test "2. Update method returns a valid user.json on update user by id", %{conn: conn, user: user} do
        conn = post(conn, session_path(conn, :create), @credential)
        assert redirected_to(conn) == page_path(conn, :lobby)

        conn = put(conn, api_user_path(conn, :update), user: @user_updates)
        assert json_response(conn, 200)["name"] == "John Doe"
        refute json_response(conn, 200)["name"] == user.name
    end

end