defmodule Portal.Relation do
    use Portal.Web, :model

    schema "relations" do
        field :tags, :string
        belongs_to :user_a, Portal.User
        belongs_to :user_b, Portal.User

        timestamps() 
    end

    def changeset(struct, params) do
        struct
        |> cast(params, [:tags])
        |> foreign_key_constraint(:user_a)
        |> foreign_key_constraint(:user_b)
    end
end