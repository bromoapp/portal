defmodule Portal.GoogleOauth2 do
    use GenServer
    require Logger
    import Process, only: [whereis: 1]

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

            config[:auth_url] <> "?" <> config[:client_id_varname] <> "="
            <> config[:client_id] <> "&scope=" <> _parse_scopes(config[:scopes], "")
            <> "&redirect_uri=" <> config[:redirect_url]
            <> "&response_type=" <> config[:response_type]
        else
            raise ArgumentError, message: "required field in config cannot be empty!"
        end
    end

    def acquire_token(code) do
        this_pid = whereis(__MODULE__)
        GenServer.call(this_pid, {:get_token, code})
    end

    def handle_cast({:put_config, config}, state) do
        {:noreply, [config: config]}
    end

    def handle_call({:get_token, code}, _from, state) do
        Logger.info(">>> CODE: #{inspect code} STATE: #{inspect state}")
        {:reply, :ok, state}
    end

    defp _is_valid?(config) when is_list(config) do
        a = (nil != config[:client_id])
        b = (nil != config[:client_secret])
        c = (nil != config[:redirect_url])
        d = (nil != config[:scopes])
        e = ([] != config[:scopes])
        f = (nil != config[:auth_url])
        g = (nil != config[:client_id_varname])
        h = (nil != config[:response_type])
        i = (nil != config[:token_url])

        a && b && c && d && e && f && g && h && i
    end

    defp _parse_scopes([], scopes) do
        scopes
    end

    defp _parse_scopes([h|t], scopes) do
        nscopes = scopes <> h <> "%20"
        _parse_scopes(t, nscopes)
    end
end