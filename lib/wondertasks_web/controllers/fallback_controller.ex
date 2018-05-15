defmodule WondertasksWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use WondertasksWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(WondertasksWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, _multi, changesets, _completed}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(WondertasksWeb.ChangesetView, "error_list.json", changesets: changesets)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(WondertasksWeb.ErrorView, :"404")
  end
end
