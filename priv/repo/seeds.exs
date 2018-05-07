import Wondertasks.Factory

Wondertasks.Repo.transaction fn ->
  g1 = insert(:group, name: "Purchases")

  t1 = insert(:task, group: g1, text: "Go to the bank", completed_at: nil)
  t2 = insert(:task, group: g1, text: "Buy hammer", parents: [t1], completed_at: nil)
  t3 = insert(:task, group: g1, text: "Buy wood", parents: [t1], completed_at: nil)
  t4 = insert(:task, group: g1, text: "Buy nails", parents: [t1], completed_at: nil)
  t5 = insert(:task, group: g1, text: "Buy paint", parents: [t1], completed_at: nil)

  g2 = insert(:group, name: "Build Airplane")

  t6 = insert(:task, group: g2, text: "Hammer nails into wood", parents: [t2, t3, t4], completed_at: nil)
  _t7 = insert(:task, group: g2, text: "Paint wings", parents: [t5, t6], completed_at: nil)
  # _t8 = insert(:task, group: g2, text: "Have a snack", parents: [], completed_at: nil)
end
