defmodule Portal.Image do
    use Portal.Web, :model

    schema "images" do
        field :owner_id, :binary_id
        field :tag, :string
        field :name, :string
        field :ext, :string
        field :size, :integer
        field :file, :binary

        timestamps()
    end
end