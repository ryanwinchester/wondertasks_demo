defmodule Wondertasks.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Wondertasks.Repo
  alias Wondertasks.Tasks.{Group, Task}

  schema "tasks" do
    field :completed_at, :naive_datetime
    field :text, :string
    field :completing_group?, :boolean, virtual: true
    belongs_to :group, Group
    many_to_many :parents, Task,
      join_through: "task_dependencies",
      join_keys: [child_id: :id, parent_id: :id],
      on_replace: :delete
    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task = Repo.preload(task, :parents)

    task
    |> Repo.preload(:parents)
    |> cast(attrs, [:text, :completed_at, :group_id, :completing_group?])
    |> validate_required([:text, :group_id])
    |> validate_can_complete(task)
    |> put_assoc(:parents, Map.get(attrs, "parents", []))
  end

  defp validate_can_complete(changeset, %Task{parents: parents, group_id: group_id}) do
    completed_at = get_change(changeset, :completed_at)

    parents =
      case get_change(changeset, :completing_group?) do
        true -> Enum.filter(parents, &(&1.group_id != group_id))
        nil -> parents
      end

    all_complete? = Enum.all?(parents, &(&1.completed_at))

    case {completed_at, all_complete?} do
      {nil, _} -> changeset
      {_, true} -> changeset
      _ -> add_error(changeset, :parents, "Can't mark a task completed without all dependents completed.")
    end
  end
end
