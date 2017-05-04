defmodule Portal.MemberTest do
  use Portal.ModelCase

  alias Portal.Member
  alias Portal.Room
  alias Portal.User

  @valid_attrs %{role: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    params = Map.put(@valid_attrs, :user, %{
        name: "some name",
        username: "username",
        password: "password"
    })
    |> Map.put(:room, %{
        name: "some room",
        mode: "some mode"
    })
    changeset = Member.changeset(%Member{}, params)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Member.changeset(%Member{}, @invalid_attrs)
    refute changeset.valid?
  end
end
