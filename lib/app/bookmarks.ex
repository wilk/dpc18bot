defmodule App.Bookmarks do
  use Agent

  # define the state
  def start_link() do
    Agent.start_link(fn() -> [] end, name: :bookmarks)
  end

  # fetch the state
  def get() do
    Agent.get(:bookmarks, fn(bookmarks) -> bookmarks end)
  end

  # add a talk to the bookmarks
  def add(talk) do
    Agent.update(:bookmarks, fn(bookmarks) -> bookmarks ++ [talk] end)
  end

  # remove a talk from the bookmarks
  def remove(talk) do
    Agent.update(:bookmarks, fn(bookmarks) -> bookmarks -- [talk] end)
  end
end
