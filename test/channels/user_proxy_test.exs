defmodule Portal.UserProxyTest do
    use Portal.ChannelCase
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

        # create relation changeset for inserting new relation
        rel_map = %{tags: "#some_tag#"}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)

        rel_cs = Relation.create_changeset(%Relation{}, rel_map)
            |> put_assoc(:user_a, user_a)
            |> put_assoc(:user_b, user_b)
        assert rel_cs.valid?
        rel = Repo.insert!(rel_cs)

        token_a = Phoenix.Token.sign(socket(), "portal_salt", user_a)
        {:ok, socket_a} = connect(UserSocket, %{"token" => token_a})
        
        token_b = Phoenix.Token.sign(socket(), "portal_salt", user_b)
        {:ok, socket_b} = connect(UserSocket, %{"token" => token_b})

        {:ok, socket_a: socket_a, user_a: user_a}
    end

    test "1. Join channel succeed", %{socket_a: socket, user_a: user} do
        {:ok, reply, _socket} = subscribe_and_join(socket, "user_proxy:my_username_a", %{})
        assert reply == %{}
    end
end