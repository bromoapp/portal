defmodule Portal.RelationTest do
    use Portal.ModelCase
    alias Portal.Relation
    alias Portal.User
    
    @user_a %{name: "my_name_a", username: "my_username_a", password: "my_password_a"}
    @user_b %{name: "my_name_b", username: "my_username_b", password: "my_password_b"}

    test "1. Success in inserting new relation when all input params are correct" do
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

        # create relation changeset for inserting new relation
        rel_map = %{tags: "#some_tag#"}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)

        rel_cs = Relation.create_changeset(%Relation{}, rel_map)
            |> put_assoc(:user_a, user_a)
            |> put_assoc(:user_b, user_b)
        assert rel_cs.valid?
        rel = Repo.insert!(rel_cs)

        rel = Relation
            |> Repo.get!(rel.id)
            |> Repo.preload(:user_a)
            |> Repo.preload(:user_b)

        assert rel.user_a.id == user_a.id
        assert rel.user_b.id == user_b.id
    end
end