defmodule WondertasksWeb.TaskControllerTest do
  use WondertasksWeb.ConnCase

  alias Wondertasks.Tasks.Task

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  defp create_task(_) do
    {:ok, task: insert(:task)}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      task = insert(:task)
      conn = get(conn, task_path(conn, :index))
      assert [json] = json_response(conn, 200)
      assert json["task"] === task.text
      assert NaiveDateTime.compare(
          NaiveDateTime.from_iso8601!(json["completedAt"]),
          task.completed_at
        ) === :eq
      assert json["group"] === task.group.name
    end

    test "lists all tasks in a group", %{conn: conn} do
      group = insert(:group)
      task = insert(:task, group: group)
      conn = get(conn, group_task_path(conn, :index, group))
      assert [json] = json_response(conn, 200)
      assert json["task"] === task.text
      assert NaiveDateTime.compare(
          NaiveDateTime.from_iso8601!(json["completedAt"]),
          task.completed_at
        ) === :eq
      assert json["group"] === task.group.name
    end
  end

  describe "create task" do
    test "renders task when data is valid", %{conn: conn} do
      data = string_params_with_assocs(:task)
      conn = post conn, task_path(conn, :create), task: data
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, task_path(conn, :show, id))
      assert json = json_response(conn, 200)
      assert is_number(json["id"])
      assert NaiveDateTime.compare(
        NaiveDateTime.from_iso8601!(json["completedAt"]),
        NaiveDateTime.from_iso8601!(data["completed_at"])
      ) === :eq
      assert json["task"] === data["text"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      data = string_params_for(:task)
      conn = post(conn, task_path(conn, :create), task: data)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup [:create_task]

    test "renders task when data is valid", %{conn: conn, task: %Task{id: id} = task} do
      data = string_params_for(:task)
      conn = put conn, task_path(conn, :update, task), task: data
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, task_path(conn, :show, id))
      assert json = json_response(conn, 200)
      assert json["id"] === id
      assert NaiveDateTime.compare(
        NaiveDateTime.from_iso8601!(json["completedAt"]),
        task.completed_at
      ) === :eq
      assert json["task"] === data["text"]
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      data = string_params_for(:task, text: -1)
      conn = put conn, task_path(conn, :update, task), task: data
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete conn, task_path(conn, :delete, task)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get(conn, task_path(conn, :show, task))
      end
    end
  end
end
