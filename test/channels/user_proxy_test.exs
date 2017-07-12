defmodule Portal.UserProxyTest do
    use Portal.ChannelCase
    alias Phoenix.Token
    alias Portal.UserSocket
    require Logger
    
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

        {:ok, socket_a: socket_a, user_a: user_a, socket_b: socket_b, user_b: user_b}
    end

    test "1. User A successfully join the channel and get initial updates", %{socket_a: socket, user_a: user} do
        {:ok, reply, _socket} = subscribe_and_join(socket, "user_proxy:" <> user.username, %{})
        %Portal.Updates{chats: [], friends: [%{id: _id, name: f_name, online: _online?, username: f_uname}]} = reply

        assert f_name == @user_b.name
        assert f_uname == @user_b.username
    end

    test "2. User B receives user A's status to be online, after B joined the channel", %{socket_a: socket_a, user_a: user_a, 
        socket_b: socket_b, user_b: user_b} do
        
        # User A join the channel first
        {:ok, _reply, _socket} = subscribe_and_join(socket_a, "user_proxy:" <> user_a.username, %{})

        # User B join the channel after
        {:ok, reply, _socket} = subscribe_and_join(socket_b, "user_proxy:" <> user_b.username, %{})
        %Portal.Updates{chats: [], friends: [%{id: _id, name: f_name, online: online?, username: f_uname}]} = reply

        assert f_name == @user_a.name
        assert f_uname == @user_a.username
        assert online? == true
    end

    test "3. User A will receives notification that user B is online, after B joined the channel", %{socket_a: socket_a, 
        user_a: user_a, socket_b: socket_b, user_b: user_b} do
        
        # User A join the channel first
        {:ok, _reply, _socket} = subscribe_and_join(socket_a, "user_proxy:" <> user_a.username, %{})

        # User B join the channel after that
        {:ok, _reply, _socket} = subscribe_and_join(socket_b, "user_proxy:" <> user_b.username, %{})

        # User A receives notification, that user B is just online
        assert_push("friend_online", data, 1000)
        assert data == %{id: user_b.id, name: @user_b.name, online: true, username: @user_b.username}
    end

    test "4. User A will send p2p msg to B, and B reply, then B query his persisted chats", %{socket_a: socket_a, user_a: user_a, 
        socket_b: socket_b, user_b: user_b} do

        # User A & B join the channel
        {:ok, _reply, socket_a} = subscribe_and_join(socket_a, "user_proxy:" <> user_a.username, %{})
        {:ok, _reply, socket_b} = subscribe_and_join(socket_b, "user_proxy:" <> user_b.username, %{})

        # User A send message to B
        push(socket_a, "p2p_msg_out", %{"to" => @user_b.username, "msg" => "Hello B"})
        
        # User B receives new conversation msg from A
        assert_push("p2p_msg_new", p2p_msg_new, 1000)
        %{chats: [%{"from" => sender_a, "message" => msg_a, "time" => _}], date: _, friend_id: _, id: _, read: _} = p2p_msg_new 

        assert sender_a == @user_a.username
        assert msg_a == "Hello B"

        # User B send reply to A
        push(socket_b, "p2p_msg_out", %{"to" => @user_a.username, "msg" => "Hello A"})

        # User A receives reply msg from B
        assert_push("p2p_msg_in", p2p_msg_in, 1000)
        %{chats: [%{"from" => sender_b, "message" => msg_b, "time" => _}], date: _, friend_id: _, id: id, read: _} = p2p_msg_in 
        
        assert sender_b == @user_b.username
        assert msg_b == "Hello A"

        # User B queries his chats from server
        ref = push(socket_b, "query_chats", %{"id" => id})
        assert_reply(ref, :ok,%{"query_chats_resp" => result}, 1000)
        
        assert length(result.chats) == 2
    end

    test "5. User A will send invitation to B, and B reveives it", %{socket_a: socket_a, user_a: user_a, 
        socket_b: socket_b, user_b: user_b} do
        
        # Both users are join the channel
        {:ok, _reply, socket_a} = subscribe_and_join(socket_a, "user_proxy:" <> user_a.username, %{})
        {:ok, _reply, _socket} = subscribe_and_join(socket_b, "user_proxy:" <> user_b.username, %{})

        # User A send invitation to B
        push(socket_a, "add_friend_out", %{"email" => user_b.username, "msg" => "Let me be your friend"})

        # User B received A's invitation
        assert_push("add_friend_in", add_friend_in, 1000)
        assert add_friend_in.msg == "Let me be your friend"
    end
end