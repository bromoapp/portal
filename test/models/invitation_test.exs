defmodule Portal.InvitationTest do
    use Portal.ModelCase
    alias Portal.Invitation
    alias Portal.User
    require Logger

    @user_a %{name: "my_name_a", username: "my_username_a", password: "my_password_a"}
    @user_b %{name: "my_name_b", username: "my_username_b", password: "my_password_b"}

    setup do
        # create user changeset for inserting a user
        user_a_cs = User.create_changeset(%User{}, @user_a)
        assert user_a_cs.valid?
        
        user_a = Repo.insert!(user_a_cs)
        #user_a = %{id: a_id, name: a_name, username: a_username, password: a_password}

        # create user changeset for inserting b user
        user_b_cs = User.create_changeset(%User{}, @user_b)
        assert user_b_cs.valid?

        user_b = Repo.insert!(user_b_cs)
        #user_b = %{id: b_id, name: b_name, username: b_username, password: b_password}

        {:ok, from: user_a, to: user_b}
    end

    test "1. User A invites user B", %{from: from, to: to} do
        invit_map = %{invit_type: "FRIENDSHIP", invit_msg: "Hi this is A"}
            |> Map.put(:from, from)
            |> Map.put(:to, to)
        invit_cs = Invitation.create_changeset(%Invitation{}, invit_map)
            |> put_assoc(:from, from)
            |> put_assoc(:to, to)
        assert invit_cs.valid?
        invit = Repo.insert!(invit_cs)

        latest_invit = Invitation
            |> Repo.get!(invit.id)
            |> Repo.preload(:from)
            |> Repo.preload(:to)

        assert latest_invit.from.id == from.id
        assert latest_invit.to.id == to.id
        assert latest_invit.invit_type == "FRIENDSHIP"
        assert latest_invit.invit_msg == "Hi this is A"
        assert latest_invit.status == "WAIT"
    end

end