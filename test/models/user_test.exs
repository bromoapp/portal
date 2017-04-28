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

    test "User.changeset returns valid == false, when building new user input form" do
        changeset = User.changeset(%User{})
        refute changeset.valid?
    end

    test "User.register_changeset returns valid == true, when all input params are correct" do
        changeset = User.register_changeset(%User{}, @valid_input)
        assert changeset.valid?
    end

    test "User.register_changeset returns valid == false, when any of required param not present" do
        changeset = User.register_changeset(%User{}, @invalid_input_no_passwd)
        refute changeset.valid?
    end

    test "User.register_changeset returns valid == false, when password less than 5 chars" do
        changeset = User.register_changeset(%User{}, @invalid_input_passwd_less_than_6)
        refute changeset.valid?
    end

    test "User.register_changeset returns valid == false, when username bigger than 20 chars" do
        changeset = User.register_changeset(%User{}, @invalid_input_uname_bigger_than_20)
        refute changeset.valid?
    end
    
end
