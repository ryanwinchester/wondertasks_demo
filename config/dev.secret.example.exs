use Mix.Config

# Configure your database
config :wondertasks, Wondertasks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wondertasks_dev",
  hostname: "localhost",
  pool_size: 10
