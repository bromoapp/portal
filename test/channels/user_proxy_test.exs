defmodule Portal.UserProxyTest do
    use Portal.ChannelCase
    alias Phoenix.Token
    alias Portal.UserSocket
    require Logger
    
    @user_a %{name: "my_name_a", username: "my_username_a", password: "my_password"}
    @user_b %{name: "my_name_b", username: "my_username_b", password: "my_password"}

    # Constant
    @accepted "ACCEPTED"
    @friendship "FRIENDSHIP"
    @membership "MEMBERSHIP"

    # Event topics
    @friend_new "friend_new"
    @friend_online "friend_online"
    @query_chats "query_chats"
    @p2p_msg_in "p2p_msg_in"
    @p2p_msg_out "p2p_msg_out"
    @p2p_msg_new "p2p_msg_new"
    @p2p_msg_read "p2p_msg_read"
    @add_friend_in "add_friend_in"
    @add_friend_out "add_friend_out"
    @add_friend_resp "add_friend_resp"
    @invit_opened "invit_opened"
    @group_new "group_new"
    @group_update "group_update"
    @add_group_in "add_group_in"
    @add_group_out "add_group_out"
    @add_group_resp "add_group_resp"

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
        assert_push(@friend_online, data, 1000)
        assert data == %{id: user_b.id, name: @user_b.name, online: true, username: @user_b.username}
    end

    test "4. User A will send p2p msg to B, and B reply, then B query his persisted chats", %{socket_a: socket_a, user_a: user_a, 
        socket_b: socket_b, user_b: user_b} do

        # User A & B join the channel
        {:ok, _reply, socket_a} = subscribe_and_join(socket_a, "user_proxy:" <> user_a.username, %{})
        {:ok, _reply, socket_b} = subscribe_and_join(socket_b, "user_proxy:" <> user_b.username, %{})

        # User A send message to B
        push(socket_a, @p2p_msg_out, %{"to" => @user_b.username, "msg" => "Hello B"})
        
        # User B receives new conversation msg from A
        assert_push(@p2p_msg_new, p2p_msg_new, 1000)
        %{chats: [%{"from" => sender_a, "message" => msg_a, "time" => _}], date: _, counter_id: _, id: a_p2p_msg_id, read: _, type: _} = p2p_msg_new 

        # User B notify the server that received p2p msg from A has read
        push(socket_b, @p2p_msg_read, %{"id" => a_p2p_msg_id})

        assert sender_a == @user_a.username
        assert msg_a == "Hello B"

        # User B send reply to A
        push(socket_b, @p2p_msg_out, %{"to" => @user_a.username, "msg" => "Hello A"})

        # User A receives reply msg from B
        assert_push(@p2p_msg_in, p2p_msg_in, 1000)
        %{chats: [%{"from" => sender_b, "message" => msg_b, "time" => _}], date: _, counter_id: _, id: b_p2p_msg_id, read: _, type: _} = p2p_msg_in
        Logger.warn("") 
        
        # User A notify the server that received p2p msg from B has read
        push(socket_b, @p2p_msg_read, %{"id" => b_p2p_msg_id})

        assert sender_b == @user_b.username
        assert msg_b == "Hello A"

        # User A queries his chats from server
        a_ref = push(socket_a, @query_chats, %{"id" => a_p2p_msg_id})
        assert_reply(a_ref, :ok,%{"query_chats_resp" => a_result}, 1000)
        
        # Check that the read status already equals to true
        assert a_result.read == 1

        # Check that the total chats in this conversation is 2
        # Logger.warn(">>> CHATS: #{inspect a_result.chats}")
        assert length(a_result.chats) == 2

        # User B queries his chats from server
        b_ref = push(socket_b, @query_chats, %{"id" => b_p2p_msg_id})
        assert_reply(b_ref, :ok,%{"query_chats_resp" => b_result}, 1000)
        
        # Check that the read status already equals to true
        assert b_result.read == 1

        # Check that the total chats in this conversation is 2
        assert length(b_result.chats) == 2
    end

    test "5. User A will send friendship invitation to B, and B reveives it", %{socket_a: socket_a, user_a: user_a, 
        socket_b: socket_b, user_b: user_b} do
        
        # Both users are join the channel
        {:ok, _reply, socket_a} = subscribe_and_join(socket_a, "user_proxy:" <> user_a.username, %{})
        {:ok, _reply, socket_b} = subscribe_and_join(socket_b, "user_proxy:" <> user_b.username, %{})

        # User A send invitation to B
        push(socket_a, @add_friend_out, %{"email" => user_b.username, "msg" => "Let me be your friend"})

        # User B received A's invitation
        assert_push(@add_friend_in, friend_invit, 1000)
        assert friend_invit.type == @friendship

        # User B notify the server that received inivitation has opened
        push(socket_b, @invit_opened, %{"id" => friend_invit.id})

        # User B accept friend request inivit
        push(socket_b, @add_friend_resp, %{"id" => friend_invit.id, "resp" => @accepted})
        
        assert_push(@friend_new, friend_new, 1000)
        %{id: _, name: a_name, online: _, username: a_username} = friend_new
        assert a_name == @user_a.name
        assert a_username == @user_a.username
    end

    test "6. User A creates a group that includes B as its member", %{socket_a: socket_a, user_a: user_a, 
        socket_b: socket_b, user_b: user_b} do
        
        # Both users are join the channel
        {:ok, _reply, socket_a} = subscribe_and_join(socket_a, "user_proxy:" <> user_a.username, %{})
        {:ok, _reply, socket_b} = subscribe_and_join(socket_b, "user_proxy:" <> user_b.username, %{})
        
        # User A creates a group with B as member
        group_name = "my_group"
        group_members = [Integer.to_string(user_b.id)]
        push(socket_a, @add_group_out, %{"name" => group_name, "members" => group_members})

        # User A receives a new group data
        assert_push(@group_new, a_new_group, 1000)
        assert a_new_group.name == group_name

        # User B receives a new group invitation
        assert_push(@add_group_in, group_invit, 1000)
        assert group_invit.type == @membership

        # User B notify the server that received inivitation has opened
        push(socket_b, @invit_opened, %{"id" => group_invit.id})

        # User B accept group membership request inivit
        push(socket_b, @add_group_resp, %{"id" => group_invit.id, "resp" => @accepted})

        # User B receives a new group data
        assert_push(@group_new, b_new_group, 1000)
        assert b_new_group.name == group_name

        # User A receives a group update data with members == 2
        assert_push(@group_update, a_upd_group, 1000)
        assert length(a_upd_group.members) == 2
    end

end