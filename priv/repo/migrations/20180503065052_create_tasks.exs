defmodule Wondertasks.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :text, :string, null: false
      add :completed_at, :naive_datetime
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index(:tasks, [:group_id])
  end
end
