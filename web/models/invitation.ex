defmodule Portal.Invitation do
    use Portal.Web, :model

    schema "invitations" do
        belongs_to :from, Portal.User
        belongs_to :to, Portal.User
        field :invit_type, :string
        field :invit_msg, :string
        field :status, :string, default: "WAIT"
        field :opened, :boolean, default: false

        timestamps()
    end

    def create_or_update_changeset(struct, params) do
        struct
        |> cast(params, [:invit_type, :invit_msg, :status])
        |> validate_required([:invit_type])
        |> foreign_key_constraint(:from_id)
        |> foreign_key_constraint(:to_id)
    end
end