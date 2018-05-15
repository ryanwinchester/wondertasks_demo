defmodule Wondertasks.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi

  alias Wondertasks.Repo

  alias Wondertasks.Tasks.{Group, Task}

  # ----------------------------------------------------------------------------
  # Groups
  # ----------------------------------------------------------------------------

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, %{"mark_tasks_complete" => true} = attrs) do
    group = Repo.preload(group, :tasks)

    complete_group_tasks = fn _ ->
      now = NaiveDateTime.utc_now()
      group.tasks
      |> Enum.map(&update_task(&1, %{"completing_group?" => true, "completed_at" => now}))
      |> Enum.reduce({:ok, []}, fn
          {:ok, task}, {:ok, tasks} -> {:ok, [task | tasks]}
          {:ok, _task}, {:error, changesets} -> {:error, changesets}
          {:error, changeset}, {:ok, _tasks} -> {:error, [changeset]}
          {:error, changeset}, {:error, changesets} -> {:error, [changeset | changesets]}
        end)
    end

    Multi.new()
    |> Multi.run(:complete_group_tasks, complete_group_tasks)
    |> Multi.update(:group, Group.changeset(group, attrs))
    |> Repo.transaction()
  end

  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{source: %Group{}}

  """
  def change_group(%Group{} = group) do
    Group.changeset(group, %{})
  end

  # ----------------------------------------------------------------------------
  # Tasks
  # ----------------------------------------------------------------------------

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    from(
      t in Task,
      preload: [:group, :parents],
      order_by: [asc: :inserted_at]
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of tasks in a Group.

  ## Examples

      iex> list_tasks(1)
      [%Task{}, ...]

  """
  def list_tasks(group_id) do
    from(
      t in Task,
      where: t.group_id == ^group_id,
      preload: [:group, :parents],
      order_by: [asc: :inserted_at]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end
end
