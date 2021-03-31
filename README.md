# Transaction

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


## Description

Transaction module made to get the payment of a bus ticket and register its corresponding record in database.

It has two main functionalities:

> Get ticket payment: It is done when the QR code reader of a bus reads a QR code and then with the subtracted data it tries to get the money from the user's wallet.

> Recharge wallet: When a user recharge his wallet the balance must be updated.
