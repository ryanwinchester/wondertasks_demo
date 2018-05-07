defmodule Wondertasks.Repo.Migrations.CreateTaskDependencies do
  use Ecto.Migration

  def change do
    create table(:task_dependencies) do
      add :child_id, references(:tasks, on_delete: :delete_all)
      add :parent_id, references(:tasks, on_delete: :delete_all)
    end

    create index(:task_dependencies, [:child_id])
    create index(:task_dependencies, [:parent_id])
  end
end
