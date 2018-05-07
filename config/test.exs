use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wondertasks, WondertasksWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :wondertasks, Wondertasks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wondertasks_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Import user-specific config
if Path.expand("test.secret.exs", __DIR__) |> File.exists?() do
  import_config("test.secret.exs")
end