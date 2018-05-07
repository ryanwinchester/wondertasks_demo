defmodule WondertasksWeb.GroupControllerTest do
  use WondertasksWeb.ConnCase

  alias Wondertasks.Tasks.Group

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  defp create_group(_) do
    {:ok, group: insert(:group)}
  end

  describe "index" do
    test "lists all groups", %{conn: conn} do
      conn = get conn, group_path(conn, :index)
      assert json_response(conn, 200) == []
    end
  end

  describe "create group" do
    test "renders group when data is valid", %{conn: conn} do
      data = string_params_for(:group)
      conn = post conn, group_path(conn, :create), group: data
      assert %{"id" => id} = json_response(conn, 201)

      conn = get conn, group_path(conn, :show, id)
      assert json = json_response(conn, 200)
      assert json["id"] == id
      assert json["name"] == data["name"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      data = string_params_for(:group, name: -1)
      conn = post conn, group_path(conn, :create), group: data
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update group" do
    setup [:create_group]

    test "renders group when data is valid", %{conn: conn, group: %Group{id: id} = group} do
      data = string_params_for(:group)
      conn = put conn, group_path(conn, :update, group), group: data
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get conn, group_path(conn, :show, id)
      assert json = json_response(conn, 200)
      assert json["id"] == id
      assert json["name"] == data["name"]
    end

    test "renders errors when data is invalid", %{conn: conn, group: group} do
      data = string_params_for(:group, name: -1)
      conn = put conn, group_path(conn, :update, group), group: data
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete group" do
    setup [:create_group]

    test "deletes chosen group", %{conn: conn, group: group} do
      conn = delete conn, group_path(conn, :delete, group)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, group_path(conn, :show, group)
      end
    end
  end
end
