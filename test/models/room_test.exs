defmodule Portal.RoomTest do
    use Portal.ModelCase
    alias Portal.Room

    @valid_attrs %{mode: "some content", name: "some content"}
    @invalid_attrs %{}

    test "changeset with valid attributes" do
      changeset = Room.changeset(%Room{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = Room.changeset(%Room{}, @invalid_attrs)
      refute changeset.valid?
    end
end
