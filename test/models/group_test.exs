defmodule Portal.GroupTest do
    use Portal.ModelCase
    alias Portal.User
    alias Portal.Group
    require Logger

    @user_a %{name: "my_name_a", username: "my_username_a", password: "my_password_a"}
    @user_b %{name: "my_name_b", username: "my_username_b", password: "my_password_b"}
    @user_c %{name: "my_name_c", username: "my_username_c", password: "my_password_c"}
    @group %{name: "my group"}

    setup do
        # create user changeset for inserting a user
        user_a_cs = User.create_changeset(%User{}, @user_a)
        assert user_a_cs.valid?
        
        user_a = Repo.insert!(user_a_cs)
        #user_a = %{id: a_id, name: my_name_a, username: my_username_a, password: my_password_a}

        # create user changeset for inserting b user
        user_b_cs = User.create_changeset(%User{}, @user_b)
        assert user_b_cs.valid?

        user_b = Repo.insert!(user_b_cs)
        #user_b = %{id: b_id, name: my_name_b, username: my_username_b, password: my_password_b}

        # create user changeset for inserting c user
        user_c_cs = User.create_changeset(%User{}, @user_c)
        assert user_c_cs.valid?

        user_c = Repo.insert!(user_c_cs)
        #user_c = %{id: c_id, name: my_name_c, username: my_username_c, password: my_password_c}
        list = [user_b, user_c]
        {:ok, from: user_a, to: list}
    end

    test "1. A creates a group and add B & C as members", %{from: user_a, to: list} do
       group_cs = _create_group_cs(%{from: user_a, to: list})
       assert group_cs.valid? == true
    end

    test "2. Remove B from membership", %{from: user_a, to: list} do
        # Creates a group with 2 members
        group_cs = _create_group_cs(%{from: user_a, to: list})
        assert group_cs.valid?
        ogroup = _persist_group(group_cs)
        osplit = String.split(ogroup.members, ",")

        # Assert members = 2
        assert length(osplit) == 2

        # Removes one member from the group
        [_, user_c] = list
        members = "#" <> Integer.to_string(user_c.id) <> "#"
        upd_cs = Group.create_or_update_changeset(ogroup, %{members: members})
        Repo.update(upd_cs)

        ngroup = Repo.get(Group, ogroup.id)
        nsplit = String.split(ngroup.members, ",")

        #Assert members = 1
        assert length(nsplit) == 1
    end

    defp _create_group_cs(%{from: user_a, to: list}) do
        [user_b, user_c] = list
        admins = "#" <> Integer.to_string(user_a.id) <> "#"
        members = "#" <> Integer.to_string(user_b.id) <> "#,#" <> Integer.to_string(user_c.id) <> "#"
        
        group_map = %{name: @group.name, admins: admins, members: members}
        Group.create_or_update_changeset(%Group{}, group_map)
    end

    defp _persist_group(group_cs) do
        Repo.insert!(group_cs)
    end

end