defmodule Wondertasks.Tasks.Group do
  use Ecto.Schema
  import Ecto.Changeset

  alias Wondertasks.Tasks.{Group, Task}

  schema "groups" do
    field :name, :string
    has_many :tasks, Task
    timestamps()
  end

  @doc false
  def changeset(%Group{} = group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
