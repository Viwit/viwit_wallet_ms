use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :transaction, Transaction.Repo,
username: "mklmanyrolpagt",
password: "4c3eabeadefef1ed0f8caf1b19ac902d8fc2cd7d6633774673cf8d30c3e3c318",
database: "d4p3p9640cl5u4",
hostname: "ec2-34-225-103-117.compute-1.amazonaws.com",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :transaction, TransactionWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
