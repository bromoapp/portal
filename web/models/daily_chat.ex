defmodule Portal.DailyChat do
    use Portal.Web, :model

    schema "daily_chats" do
        belongs_to :user_a, Portal.User
        belongs_to :user_b, Portal.User
        field :messages, :string

        timestamps()
    end

end