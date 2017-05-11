defmodule Portal.Invitation do
    use Portal.Web, :model

    schema "invitations" do
        field :message, :string
        belongs_to :to_user, Portal.User
        belongs_to :from_user, Portal.User

        timestamps()
    end

    def changeset(struct, params) do
        struct
        |> cast(params, [:message])
        |> foreign_key_constraint(:to_user)
        |> foreign_key_constraint(:from_user)
    end
end