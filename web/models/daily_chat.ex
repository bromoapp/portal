defmodule Portal.DailyChat do
    use Portal.Web, :model

    schema "daily_chats" do
        field :messages, :string
        belongs_to :user_a, Portal.User
        belongs_to :user_b, Portal.User

        timestamps()
    end

    def create_changeset(struct, params) do
        struct
        |> cast(params, [:messages])
        |> foreign_key_constraint(:user_a)
        |> foreign_key_constraint(:user_b)
    end

end