defmodule Portal.GoogleOauth2 do
    use GenServer
    alias HTTPotion.Response
    require Logger
    import Process, only: [whereis: 1]

    @auth_url "https://accounts.google.com/o/oauth2/auth"
    @token_url "https://accounts.google.com/o/oauth2/token"
    @profile_url "https://www.googleapis.com/oauth2/v2/userinfo?access_token="
    
    def start_link(args \\ nil) do
        GenServer.start_link(__MODULE__, args, name: __MODULE__)
    end

    def init(_args) do
        {:ok, []}
    end
    
    def auth_url(config) when is_list(config) do
        if _is_valid?(config) do
            this_pid = whereis(__MODULE__)
            GenServer.cast(this_pid, {:put_config, config})

            @auth_url <> "?client_id=" <> config[:client_id] 
            <> "&scope=" <> _parse_scopes(config[:scopes], "")
            <> "&redirect_uri=" <> config[:redirect_url]
            <> "&response_type=code"
        else
            raise ArgumentError, message: "required field in config cannot be empty!"
        end
    end

    def acquire_token(code) do
        this_pid = whereis(__MODULE__)
        GenServer.call(this_pid, {:acquire_token, code})
    end

    def acquire_profile(token) do
        this_pid = whereis(__MODULE__)
        GenServer.call(this_pid, {:acquire_profile, token})
    end

    def handle_cast({:put_config, config}, state) do
        {:noreply, [config: config]}
    end

    def handle_call({:acquire_token, code}, _from, state) do
        %Response{body: body, headers: _, status_code: status} = HTTPotion.post @token_url, _get_token_opts(state, code)
        obj = Poison.decode(body)
        {:reply, obj, state}
    end

    def handle_call({:acquire_profile, token}, _from, state) do
        %Response{body: body, headers: _, status_code: status} = HTTPotion.get @profile_url <> token
        obj = Poison.decode(body)
        {:reply, obj, state}
    end

    defp _get_token_opts(state, code) do
        [body: _get_token_args(state[:config], code), headers: _get_token_headers()]
    end

    defp _get_token_args(state, code) do
        [
            "code=" <> code, 
            "&redirect_uri=" <> state[:redirect_url],
            "&client_secret=" <> state[:client_secret],
            "&client_id=" <> state[:client_id],
            "&grant_type=authorization_code"
        ]
    end

    defp _get_token_headers do
        ["Content-Type": "application/x-www-form-urlencoded"]
    end

    defp _is_valid?(config) when is_list(config) do
        a = (nil != config[:client_id])
        b = (nil != config[:client_secret])
        c = (nil != config[:redirect_url])
        d = (nil != config[:scopes])
        e = ([] != config[:scopes])

        a && b && c && d && e
    end

    defp _parse_scopes([], scopes) do
        scopes
    end

    defp _parse_scopes([h|t], scopes) do
        nscopes = scopes <> h <> "%20"
        _parse_scopes(t, nscopes)
    end
end