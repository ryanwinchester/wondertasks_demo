defmodule WondertasksWeb.GroupController do
  use WondertasksWeb, :controller

  alias Wondertasks.Tasks
  alias Wondertasks.Tasks.Group

  action_fallback WondertasksWeb.FallbackController

  def index(conn, _params) do
    groups = Tasks.list_groups()
    render(conn, "index.json", groups: groups)
  end

  def create(conn, %{"group" => group_params}) do
    with {:ok, %Group{} = group} <- Tasks.create_group(group_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", group_path(conn, :show, group))
      |> render("show.json", group: group)
    end
  end

  def show(conn, %{"id" => id}) do
    group = Tasks.get_group!(id)
    render(conn, "show.json", group: group)
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    group = Tasks.get_group!(id)

    case Tasks.update_group(group, group_params) do
      {:ok, %Group{} = group} -> render(conn, "show.json", group: group)
      {:ok, %{group: %Group{} = group}} -> render(conn, "show.json", group: group)
      errors -> errors
    end
  end

  def delete(conn, %{"id" => id}) do
    group = Tasks.get_group!(id)
    with {:ok, %Group{}} <- Tasks.delete_group(group) do
      send_resp(conn, :no_content, "")
    end
  end
end
