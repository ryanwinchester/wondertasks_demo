defmodule Wondertasks.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Wondertasks.Repo
  alias Wondertasks.Tasks.{Group, Task}

  schema "tasks" do
    field :completed_at, :naive_datetime
    field :text, :string
    belongs_to :group, Group
    many_to_many :parents, Task,
      join_through: "task_dependencies",
      join_keys: [child_id: :id, parent_id: :id],
      on_replace: :delete
    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> Repo.preload(:parents)
    |> cast(attrs, [:text, :completed_at, :group_id])
    |> validate_required([:text, :group_id])
    |> update_parents(attrs)
  end

  defp update_parents(changeset, %{"parents" => parents}) do
    put_assoc(changeset, :parents, parents)
  end

  defp update_parents(changeset, %{parents: parents}) do
    put_assoc(changeset, :parents, parents)
  end

  defp update_parents(changeset, _attrs), do: changeset
end
