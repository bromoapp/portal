defmodule Portal.DailyChat do
    use Portal.Web, :model
    alias Ecto.DateTime

    schema "daily_chats" do
        field :read, :boolean, default: false
        field :messages, :string
        field :type, :string
        field :counter_id, :integer
        belongs_to :user, Portal.User

        timestamps()
    end

    def create_or_update_p2p_changeset(struct, params) do
        struct
        |> cast(params, [:read, :messages, :counter_id, :type])
        |> validate_required([:read, :messages, :counter_id, :type])
        |> foreign_key_constraint(:user)
    end

    def create_or_update_p2g_changeset(struct, params) do
        struct
        |> cast(params, [:read, :messages, :counter_id, :type])
        |> validate_required([:read, :messages, :counter_id, :type])
        |> foreign_key_constraint(:user)
    end

end