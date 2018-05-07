defmodule Wondertasks.Factory do
  use ExMachina.Ecto, repo: Wondertasks.Repo

  def group_factory do
    %Wondertasks.Tasks.Group{
      name: sequence(:name, &"Group #{&1}"),
    }
  end

  def task_factory do
    %Wondertasks.Tasks.Task{
      text: sequence(:text, &"Task #{&1}"),
      completed_at: "2018-01-01 11:11:00",
      group: build(:group),
      parents: []
    }
  end
end