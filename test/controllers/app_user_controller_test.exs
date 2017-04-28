defmodule Portal.AppUserControllerTest do
    use Portal.ConnCase

    alias Portal.User
    
    @moduledoc """
    This is an integration test for Portal.AppUserController
    """

    @valid_input %{name: "my_name", username: "my_username", password: "my_password"}
    @invalid_input_no_passwd %{name: "my_name", username: "my_username"}
    @invalid_input_passwd_less_than_6 %{name: "my_name", username: "my_username", password: "_"}
    @invalid_input_uname_bigger_than_20 %{name: "my_name", username: "my_username_is_so_long_until_it_becomes_uneficient!", password: "my_password"}

    setup do
        conn = build_conn()
        |> put_req_header("accept", "application/json")
        {:ok, conn: conn}
    end

    test "Show method returns a valid user data on query user by id", %{conn: conn} do
        user = insert_user(%{name: "John Doe", username: "john_doe", password: "john_secrets"})

        conn = get(conn, app_user_path(conn, :show, user.id))
        assert json_response(conn, 200)["name"] == user.name
    end

    test "Create method returns a valid json result on a valid input", %{conn: conn} do
        conn = post(conn, app_user_path(conn, :create), user: @valid_input)
        assert json_response(conn, 201)["name"] == @valid_input.name
        assert json_response(conn, 201)["username"] == @valid_input.username
    end

    test "Create method returns json error on no password input", %{conn: conn} do
        conn = post(conn, app_user_path(conn, :create), user: @invalid_input_no_passwd)
        assert json_response(conn, 422)["errors"] == %{"password" => ["can't be blank"]}
    end

    test "Create method returns json error on input password less than 6 chars", %{conn: conn} do
        conn = post(conn, app_user_path(conn, :create), user: @invalid_input_passwd_less_than_6)
        assert json_response(conn, 422)["errors"] == %{"password" => ["should be at least 6 character(s)"]}
    end

    test "Create method returns json error on input username larger than 20 chars", %{conn: conn} do
        conn = post(conn, app_user_path(conn, :create), user: @invalid_input_uname_bigger_than_20)
        assert json_response(conn, 422)["errors"] == %{"username" => ["should be at most 20 character(s)"]}
    end

end