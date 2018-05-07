defmodule WondertasksWeb.GroupView do
  use WondertasksWeb, :view
  alias WondertasksWeb.GroupView

  def render("index.json", %{groups: groups}) do
    render_many(groups, GroupView, "group.json")
  end

  def render("show.json", %{group: group}) do
    render_one(group, GroupView, "group.json")
  end

  def render("group.json", %{group: group}) do
    %{
      id: group.id,
      name: group.name,
    }
  end
end
