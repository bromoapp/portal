defmodule Portal.WebUserControllerTest do
    use Portal.ConnCase
    
    @moduledoc """
    This is an integration test for Portal.WebUserController
    """

    @valid_input %{user: %{name: "My Name", username: "my_username", password: "my_password"}}
    @invalid_input %{user: %{name: "My Name", username: "my_username"}}

    test "1. New method returns registration page form", %{conn: conn} do
        conn = get(conn, web_user_path(conn, :new, []))
        assert html_response(conn, 200)
    end

    test "2. Create method returns lobby page on a valid input", %{conn: conn} do
        conn = post(conn, web_user_path(conn, :create), @valid_input)
        assert redirected_to(conn) == page_path(conn, :lobby)
    end

    test "3. Create method returns error on an invalid input", %{conn: conn} do
        conn = post(conn, web_user_path(conn, :create), @invalid_input)
        assert html_response(conn, 200)
    end
end