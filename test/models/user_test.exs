defmodule Portal.UserTest do
    use Portal.ModelCase
    alias Portal.User

    @moduledoc """
    This is a unit testing for Portal.User model
    """

    @valid_input    %{name: "my_name", username: "my_username", password: "my_password"}
    @invalid_input_no_passwd  %{name: "my_name", username: "my_username"}
    @invalid_input_passwd_less_than_6    %{name: "my_name", username: "my_username", password: "_"}
    @invalid_input_uname_bigger_than_20    %{name: "my_name", username: "my_username_is_so_fucking_long_until_it_become_uneficient!", password: "my_password"}

    test "1. User.changeset returns valid == false, when building new user input form" do
        changeset = User.new_changeset(%User{})
        refute changeset.valid?
    end

    test "2. User.create_changeset returns valid == true, when all input params are correct" do
        changeset = User.create_changeset(%User{}, @valid_input)
        assert changeset.valid?

        user = Repo.insert!(changeset)
        assert user.name == @valid_input.name
    end

    test "3. User.create_changeset returns valid == false, when any of required param not present" do
        changeset = User.create_changeset(%User{}, @invalid_input_no_passwd)
        refute changeset.valid?
    end

    test "4. User.create_changeset returns valid == false, when password less than 5 chars" do
        changeset = User.create_changeset(%User{}, @invalid_input_passwd_less_than_6)
        refute changeset.valid?
    end

    test "5. User.create_changeset returns valid == false, when username bigger than 20 chars" do
        changeset = User.create_changeset(%User{}, @invalid_input_uname_bigger_than_20)
        refute changeset.valid?
    end
    
end
