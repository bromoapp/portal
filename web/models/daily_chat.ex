defmodule Portal.DailyChat do
    use Portal.Web, :model
    alias Ecto.DateTime

    schema "daily_chats" do
        field :read, :boolean
        field :messages, :string
        field :inserted_at, DateTime, default: DateTime.from_erl(:calendar.local_time)
        field :updated_at, DateTime, default: DateTime.from_erl(:calendar.local_time)
        belongs_to :user_a, Portal.User
        belongs_to :user_b, Portal.User
    end

    def create_or_update_changeset(struct, params) do
        struct
        |> cast(params, [:read, :messages, :inserted_at, :updated_at])
        |> validate_required([:read, :messages, :inserted_at, :updated_at])
        |> foreign_key_constraint(:user_a)
        |> foreign_key_constraint(:user_b)
    end

end