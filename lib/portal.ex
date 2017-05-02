defmodule Portal do
    use Application

    # See http://elixir-lang.org/docs/stable/elixir/Application.html
    # for more information on OTP Applications
    def start(_type, _args) do
        join_addr = Application.get_env(:distkv, :join_addr)

        import Supervisor.Spec

        # Define workers and child supervisors to be supervised
        children = [
          # Start the Ecto repository
          supervisor(Portal.Repo, []),
          # Start the endpoint when the application starts
          supervisor(Portal.Endpoint, []),
          # Start your own worker by calling: Portal.Worker.start_link(arg1, arg2, arg3)
          # worker(Portal.Worker, [arg1, arg2, arg3]),
          worker(Portal.OnlineUsersServer, [join_addr]),
          worker(Portal.RoomsServer, [join_addr])
        ]

        # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
        # for other strategies and supported options
        opts = [strategy: :one_for_one, name: Portal.Supervisor]
        Supervisor.start_link(children, opts)
    end

    # Tell Phoenix to update the endpoint configuration
    # whenever the application is updated.
    def config_change(changed, _new, removed) do
        Portal.Endpoint.config_change(changed, removed)
        :ok
    end
end
