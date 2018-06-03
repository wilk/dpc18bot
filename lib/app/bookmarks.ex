defmodule App.Bookmarks do
  use Agent

  # todo: define the state
  # hint: use Agent.start_link fn, name: :atom
  # hint: use a list of maps %{id, title_lower, title, speaker, room, time, content}
  def start_link() do

  end

  # todo: fetch the state
  # hint: use Agent.get with :atom, fn
  def get() do

  end

  # todo: add a talk to the bookmarks
  # hint: use Agent.update with :atom, fn
  def add(talk) do

  end

  # todo: remove a talk from the bookmarks
  # hint: use Agent.update with :atom, fn
  def remove(talk) do

  end
end