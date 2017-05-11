defmodule Portal.SessionControllerTest do
    use Portal.ConnCase
    
    @moduledoc """
    This is an integration test for Portal.SessionController
    """

    @user %{name: "John Doe", username: "johndoe", password: "johndoe_pass"}
    
    setup do
        insert_user(@user)
        valid_credential = %{"session" => %{"username" => @user.username, "password" => @user.password}}
        invalid_credential = %{"session" => %{"username" => "uname", "password" => "pass"}}
        conn = build_conn()
        {:ok, conn: conn, valid_credential: valid_credential, invalid_credential: invalid_credential}
    end

    test "New method returns login page form", %{conn: conn} do
        conn = get(conn, session_path(conn, :new, []))
        assert html_response(conn, 200)
    end

    test "Create method returns redirect to lobby page on a valid credential", %{conn: conn, valid_credential: credential} do
        conn = post(conn, session_path(conn, :create), credential)
        assert redirected_to(conn) == page_path(conn, :lobby)
    end

    test "Create method returns error back to login page on an invalid credential", %{conn: conn, invalid_credential: credential} do
        conn = post(conn, session_path(conn, :create), credential)
        assert redirected_to(conn) == session_path(conn, :new)
    end
end