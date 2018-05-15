defmodule Wondertasks.TasksTest do
  use Wondertasks.DataCase

  alias Wondertasks.Tasks

  describe "groups" do
    alias Wondertasks.Tasks.Group

    test "list_groups/0 returns all groups" do
      group = insert(:group)
      assert Tasks.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = insert(:group)
      assert Tasks.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      data = params_for(:group)
      assert {:ok, %Group{} = group} = Tasks.create_group(data)
      assert group.name == data.name
    end

    test "create_group/1 with invalid data returns error changeset" do
      data = params_for(:group, name: -1)
      assert {:error, %Ecto.Changeset{}} = Tasks.create_group(data)
    end

    test "update_group/2 with valid data updates the group" do
      group = insert(:group)
      data = params_for(:group)
      assert {:ok, group} = Tasks.update_group(group, data)
      assert %Group{} = group
      assert group.name == data.name
    end

    test "update_group/2 with `mark_tasks_complete` updates the group" do
      group = insert(:group)
      insert_list(3, :task, group: group, completed_at: nil)
      data = string_params_for(:group) |> Map.put("mark_tasks_complete", true)
      assert {:ok, %{group: %Group{} = updated}} = Tasks.update_group(group, data)
      assert updated.name == data["name"]
      updated = Wondertasks.Repo.preload(updated, :tasks, force: true)
      assert Enum.all?(updated.tasks, &(&1.completed_at))
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = insert(:group)
      data = params_for(:group, name: -1)
      assert {:error, %Ecto.Changeset{}} = Tasks.update_group(group, data)
      assert group == Tasks.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = insert(:group)
      assert {:ok, %Group{}} = Tasks.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = insert(:group)
      assert %Ecto.Changeset{} = Tasks.change_group(group)
    end
  end

  describe "tasks" do
    alias Wondertasks.Tasks.Task

    test "list_tasks/0 returns all tasks" do
      task = insert(:task)
      assert [fetched] = Tasks.list_tasks()
      assert fetched.id === task.id
      assert fetched.text === task.text
      assert NaiveDateTime.compare(fetched.completed_at, task.completed_at) === :eq
    end

    test "get_task!/1 returns the task with given id" do
      task = insert(:task)
      assert fetched = Tasks.get_task!(task.id)
      assert fetched.id === task.id
      assert fetched.text === task.text
      assert NaiveDateTime.compare(fetched.completed_at, task.completed_at) === :eq
    end

    test "create_task/1 with valid data creates a task" do
      data = params_with_assocs(:task)
      assert {:ok, %Task{} = task} = Tasks.create_task(data)
      assert task.group_id === data.group_id
      assert task.text === data.text
      assert NaiveDateTime.compare(
        task.completed_at,
        NaiveDateTime.from_iso8601!(data.completed_at)
      ) === :eq
    end

    test "create_task/1 with invalid data returns error changeset" do
      data = params_for(:task)
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(data)
    end

    test "update_task/2 with valid data updates the task" do
      task = insert(:task)
      data = params_for(:task)
      assert {:ok, fetched} = Tasks.update_task(task, data)
      assert %Task{} = task
      assert fetched.text === data.text
      assert NaiveDateTime.compare(
        fetched.completed_at,
        NaiveDateTime.from_iso8601!(data.completed_at)
      ) === :eq
      assert fetched.group_id === task.group_id
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = insert(:task)
      data = params_for(:task, text: -1)
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, data)
      assert fetched = Tasks.get_task!(task.id)
      assert fetched.id === task.id
      assert fetched.text === task.text
      assert NaiveDateTime.compare(fetched.completed_at, task.completed_at) === :eq
    end

    test "delete_task/1 deletes the task" do
      task = insert(:task)
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = insert(:task)
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
