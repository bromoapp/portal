defmodule Portal.Invitation do
    use Portal.Web, :model

    @default_status "WAITING"

    schema "invitations" do
        belongs_to :to, Portal.User
        field :from_id, :integer
        field :invit_type, :string
        field :invit_msg, :string
        field :status, :string, default: @default_status
        field :opened, :boolean, default: false

        timestamps()
    end

    def create_or_update_changeset(struct, params) do
        struct
        |> cast(params, [:from_id, :invit_type, :invit_msg, :status, :opened])
        |> validate_required([:from_id, :invit_type])
        |> foreign_key_constraint(:to)
    end
end