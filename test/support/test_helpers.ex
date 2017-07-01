defmodule Portal.TestHelpers do
    alias Portal.Repo
    alias Portal.User

    def insert_user(attrs \\ %{}) do
        changes = Map.merge(%{
            name: "Some User",
            username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
            password: "supersecret"
        }, attrs)

        %Portal.User{}
        |> Portal.User.create_changeset(changes)
        |> Repo.insert!()
    end
    
end