defmodule Portal.TestHelpers do
    import Ecto.Changeset
    alias Portal.Repo
    alias Portal.User
    alias Portal.Relation

    def insert_user(attrs \\ %{}) do
        changes = Map.merge(%{
            name: "Some User",
            username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
            password: "supersecret"
        }, attrs)

        %User{}
        |> User.create_changeset(changes)
        |> Repo.insert!()
    end

    def insert_new_relation(user_a, user_b) do
        rel_map = %{tags: "#some_tag#"}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)

        rel_cs = Relation.create_changeset(%Relation{}, rel_map)
            |> put_assoc(:user_a, user_a)
            |> put_assoc(:user_b, user_b)
        Repo.insert!(rel_cs)
    end

    def insert_new_group() do
        
    end
    
end