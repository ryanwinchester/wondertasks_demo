defmodule WondertasksWeb.TaskView do
  use WondertasksWeb, :view
  alias WondertasksWeb.TaskView

  alias Wondertasks.Tasks.Task

  def render("index.json", %{tasks: tasks}) do
    render_many(tasks, TaskView, "task.json")
  end

  def render("show.json", %{task: task}) do
    render_one(task, TaskView, "task.json")
  end

  def render("task.json", %{task: task}) do
    # Setting the view to match the example payload.
    %{
      id: task.id,
      group: group_name(task),
      task: task.text,
      dependencyIds: dependency_ids(task),
      completedAt: task.completed_at,
    }
  end

  defp group_name(%Task{group: %Ecto.Association.NotLoaded{}}), do: nil
  defp group_name(%Task{group: group}), do: group.name

  defp dependency_ids(%Task{parents: %Ecto.Association.NotLoaded{}}), do: nil
  defp dependency_ids(%Task{parents: parents}), do: Enum.map(parents, &Map.get(&1, :id))
end
