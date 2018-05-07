defmodule WondertasksWeb.Router do
  use WondertasksWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", WondertasksWeb do
    pipe_through([:browser])
    get("/", PageController, :index)
  end

  scope "/api", WondertasksWeb do
    pipe_through([:api])
    resources("/groups", GroupController)
    get("/groups/:group_id/tasks", TaskController, :index, as: :group_task)
    resources("/tasks", TaskController)
  end
end
