# Wondertasks Demo

Although I've used Elixir and Phoenix a lot, this is my first time using React.js.
I almost always default to Vue.js.

I have done it all under one React component to keep it simple for myself and since I don't yet
know the best practices for many things in React land (like parent-child state relationships, etc).

> 6. Dependencies that don't point to a loaded task should be ignored

I honestly wasn't 100% sure what this requirement meant, but I'm assuming it means to just filter out any task
that depends on tasks that weren't included in the payload. Since I'm including a proper API backend with
real database relationships, including a task with a relationship that doesn't exist kind of breaks foreign key
constraints, anyway, so I just ignored it (maybe earlier than intended for the exercise). **#sorrynotsorry**

## Setup and Run

  1. Install Elixir dependencies with `mix deps.get`
  2. Install JavaScript dependencies with `yarn` (or `npm install`) in `./assets` dir
  3. If local config is different than the defaults then `cp config/dev.secret.example.exs config/dev.secret.exs`
     and `cp config/test.secret.example.exs config/test.secret.exs`, then edit accordingly
  4. Set up the database with `mix ecto.setup`
  5. Run the application with `mix phx.server`
  6. You can now visit `http://localhost:4000`

If you follow the above instructions, the database is seeded with the example payload found in the instructions.

All actions are persisted to the database, if you want to, you can reset the database with `mix ecto.reset`.

## Testing

You can run the back-end tests with `mix test`.

You can run the front-end tests with... nothing. I didn't write any 😜


## Demo

![screen recording](https://s3-us-west-2.amazonaws.com/ryanwinchester/screenshots/Screen+Recording+2018-05-06+at+10.53+PM.gif)
