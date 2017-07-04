defmodule Portal.DailyChatTest do
    use Portal.ModelCase
    alias Portal.DailyChat
    alias Portal.User
    alias Portal.Chats
    alias Portal.Chat
    alias Ecto.DateTime

    @user_a %{name: "my_name_a", username: "my_username_a", password: "my_password_a"}
    @user_b %{name: "my_name_b", username: "my_username_b", password: "my_password_b"}

    setup do
        # create user changeset for inserting a user
        user_a_cs = User.create_changeset(%User{}, @user_a)
        assert user_a_cs.valid?
        
        user_a = Repo.insert!(user_a_cs)
        #user_a = %{id: a_id, name: a_name, username: a_username, password: a_password}

        # create user changeset for inserting b user
        user_b_cs = User.create_changeset(%User{}, @user_b)
        assert user_b_cs.valid?

        user_b = Repo.insert!(user_b_cs)
        #user_b = %{id: b_id, name: b_name, username: b_username, password: b_password}

        {:ok, user_1: user_a, user_2: user_b}
    end

    test "1. Insert new daily chat success when all input params are correct", %{user_1: user_a, user_2: user_b} do
        # create daily chat
        ch1 = %Chat{from: "B", message: "Hello A", time: _get_time()}
        ch2 = %Chat{from: "A", message: "Hello B how are you", time: _get_time()}
        ch3 = %Chat{from: "B", message: "I'm fine A, you?", time: _get_time()}
        ch4 = %Chat{from: "A", message: "I'm fine too thanks B", time: _get_time()}
        chats = %Chats{chats: [ch1, ch2, ch3, ch4]}

        text = Poison.encode!(chats)
        localtime = :calendar.local_time
        dchat_map = %{read: true, messages: text}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)
        
        dchat_cs = DailyChat.create_or_update_changeset(%DailyChat{}, dchat_map)
            |> put_assoc(:user_a, user_a)
            |> put_assoc(:user_b, user_b)
        assert dchat_cs.valid?
        dchat = Repo.insert!(dchat_cs)

        dchat = DailyChat
            |> Repo.get!(dchat.id)
            |> Repo.preload(:user_a)
            |> Repo.preload(:user_b)

        assert dchat.user_a.id == user_a.id
        assert dchat.user_b.id == user_b.id
    end

    test "2. Update a daily chat success when all input params are correct", %{user_1: user_a, user_2: user_b} do
        # create first daily chat
        ch1 = %Chat{from: "B", message: "Hello A", time: _get_time()}
        ch2 = %Chat{from: "A", message: "Hello B how are you", time: _get_time()}
        ch3 = %Chat{from: "B", message: "I'm fine A, you?", time: _get_time()}
        chats = %Chats{chats: [ch1, ch2, ch3]}

        text1 = Poison.encode!(chats)
        dchat_map = %{read: true, messages: text1}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)
        
        dchat_cs = DailyChat.create_or_update_changeset(%DailyChat{}, dchat_map)
            |> put_assoc(:user_a, user_a)
            |> put_assoc(:user_b, user_b)
        assert dchat_cs.valid?
        dchat = Repo.insert!(dchat_cs)

        # update first daily chat
        odchat = DailyChat
            |> Repo.get!(dchat.id)
        
        old_msgs = odchat.messages
        old_chats = Poison.decode!(old_msgs, as: %Chats{})

        # check if total chats in original record is 3
        assert length(old_chats.chats) == 3

        ch4 = %Chat{from: "A", message: "I'm fine too thanks B", time: _get_time()}
        upd_chat_list = %Chats{chats: old_chats.chats ++ [ch4]}
        text2 = Poison.encode!(upd_chat_list)
        upd_dchat_map = %{read: false, messages: text2}
            |> Map.put(:user_a, user_a)
            |> Map.put(:user_b, user_b)

        upd_dchat_cs = DailyChat.create_or_update_changeset(odchat, upd_dchat_map)
        assert upd_dchat_cs.valid?
        udchat = Repo.update!(upd_dchat_cs)

        upd_msgs = udchat.messages
        upd_chats = Poison.decode!(upd_msgs, as: %Chats{})

        # check if total chats in updated record is 4
        assert length(upd_chats.chats) == 4
    end

    defp _get_time do
        {_, {hh, mm, ss}} = :calendar.local_time
        Integer.to_string(hh) <> ":" <> Integer.to_string(mm) <> ":" <> Integer.to_string(ss)
    end
end