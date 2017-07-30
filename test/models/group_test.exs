defmodule Portal.GroupTest do
    use Portal.ModelCase
    use Portal.User
    use Portal.Group

    @user_a %{name: "my_name_a", username: "my_username_a", password: "my_password_a"}
    @user_b %{name: "my_name_b", username: "my_username_b", password: "my_password_b"}
    @user_c %{name: "my_name_c", username: "my_username_c", password: "my_password_c"}

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
        user_c_cs = User.create_changeset(%User{}, @user_b)
        assert user_c_cs.valid?

        user_c = Repo.insert!(user_c_cs)
        #user_c = %{id: c_id, name: my_name_c, username: my_username_c, password: my_password_c}

        {:ok, from: user_a, to: [user_b, user_c]}
    end

    test "1. A creates a group and add B and C as members", %{from: from, to: to} do
        
    end
end