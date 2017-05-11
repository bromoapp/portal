defmodule Portal.Relation do
    use Portal.Web, :model

    schema "relations" do
        field :tags, :string
        belongs_to :user_a, Portal.User
        belongs_to :user_b, Portal.User

        timestamps() 
    end

    def changeset(struct, params \\ :invalid) do
        struct
        |> cast(params, [])
        |> cast_assoc(:user_a)
        |> cast_assoc(:user_b)
    end
end