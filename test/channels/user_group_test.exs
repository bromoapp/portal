defmodule Portal.UserGroupTest do
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

        # create group
        insert_new_group()
    end
end