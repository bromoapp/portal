defmodule Portal.DailyChat do
    use Portal.Web, :model
    alias Ecto.DateTime

    schema "daily_chats" do
        field :read, :boolean, default: false
        field :messages, :string
        belongs_to :user_a, Portal.User
        belongs_to :user_b, Portal.User
        belongs_to :group, Portal.Group

        timestamps()
    end

    def create_or_update_p2p_changeset(struct, params) do
        struct
        |> cast(params, [:read, :messages])
        |> validate_required([:read, :messages])
        |> foreign_key_constraint(:user_a)
        |> foreign_key_constraint(:user_b)
    end

    def create_or_update_group_changeset(struct, params) do
        struct
        |> cast(params, [:read, :messages])
        |> validate_required([:read, :messages])
        |> foreign_key_constraint(:user_a)
        |> foreign_key_constraint(:group)
    end

end