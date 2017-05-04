defmodule Portal.TestHelpers do
    alias Portal.Repo
    alias Portal.User
    alias Portal.Room
    alias Portal.Member

    def insert_user(attrs \\ %{}) do
        changes = Map.merge(%{
            name: "Some User",
            username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
            password: "supersecret"
        }, attrs)

        %Portal.User{}
        |> Portal.User.register_changeset(changes)
        |> Repo.insert!()
    end

    def insert_room(attrs \\ %{}) do
        changes = Map.merge(%{
            name: "Some room",
            mode: "Some mode"
        }, attrs)

        %Portal.Room{}
        |> Portal.Room.changeset(changes)
        |> Repo.insert!()
    end
end