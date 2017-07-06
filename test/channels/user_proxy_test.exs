defmodule Portal.UserProxyTest do
    use Portal.ChannelCase
    alias Phoenix.Token
    alias Portal.UserSocket
    alias Portal.UserProxy
    alias Portal.User
    alias Portal.Relation
    
    @user_a %{name: "my_name_a", username: "my_username_a", password: "my_password"}
    @user_b %{name: "my_name_b", username: "my_username_b", password: "my_password"}

    setup do
        # create users
        user_a = insert_user(@user_a)
        user_b = insert_user(@user_b)

        # create relation
        insert_new_relation(user_a, user_b)

        token_a = Token.sign(socket(), "portal_salt", user_a)
        {:ok, socket_a} = connect(UserSocket, %{"token" => token_a})
        
        token_b = Token.sign(socket(), "portal_salt", user_b)
        {:ok, socket_b} = connect(UserSocket, %{"token" => token_b})

        {:ok, socket_a: socket_a, user_a: user_a}
    end

    test "1. Join channel succeed and get initial updates", %{socket_a: socket, user_a: user} do
        {:ok, reply, _socket} = subscribe_and_join(socket, "user_proxy:" <> @user_a.username, %{})
        %Portal.Updates{chats: [], friends: [%{id: _id, name: f_name, online: false, username: f_uname}]} = reply
        assert f_name == @user_b.name
        assert f_uname == @user_b.username
    end
end