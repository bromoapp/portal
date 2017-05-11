defmodule Portal.RelationTest do
    use Portal.ModelCase
    alias Portal.Relation
    alias Portal.User
    
    @user_a %{name: "my_name_a", username: "my_username_a", password: "my_password_a"}
    @user_b %{name: "my_name_b", username: "my_username_b", password: "my_password_b"}

    test "Relation.changeset returns valid == true, when all input params correct" do
        user_a_cs = User.register_changeset(%User{}, @user_a)
        assert user_a_cs.valid?
        
        %User{id: a_id, name: a_name, username: a_username, password: a_password} = Repo.insert!(user_a_cs)
        user_a = %{id: a_id, name: a_name, username: a_username, password: a_password}

        user_b_cs = User.register_changeset(%User{}, @user_b)
        assert user_b_cs.valid?

        %User{id: b_id, name: b_name, username: b_username, password: b_password} = Repo.insert!(user_b_cs)
        user_b = %{id: b_id, name: b_name, username: b_username, password: b_password}

        rel_map = %{tags: "#just_tag#"}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)

        rel_cs = Relation.changeset(%Relation{}, rel_map)
        assert rel_cs.valid?

        rel = Repo.insert!(rel_cs)
'''
        rel = Relation 
            |> Repo.get(rel.id) 
            |> Repo.preload(:user_a) 
            |> Repo.preload(:user_b)

        assert rel.user_a.name == @user_a.name
'''
    end
end