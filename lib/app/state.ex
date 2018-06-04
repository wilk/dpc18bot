defmodule App.State do
  use Agent

  def start_link() do
    {:ok, res} = with {:ok, body} <- File.read("lib/app/dpc.json"),
                      {:ok, json} <- Poison.decode(body), do: {:ok, json}
    
    speakers = res 
      |> Enum.uniq_by(fn(el) -> Map.get(el, "speaker") end)
      |> Enum.map(fn(el) -> 
        name = Map.get(el, "speaker") |> String.replace("_", "-")
        %{"lower_name" => String.downcase(name), "name" => name, "bio" => Map.get(el, "bio") |> String.replace("_", "-")} 
      end)

    schedule = res
      |> Enum.uniq_by(fn(el) -> Map.get(el, "id") end)
      |> Enum.map(fn(el) -> 
        title = Map.get(el, "title")
        %{
          "id" => Map.get(el, "id"),
          "title_lower" => title |> String.downcase(), 
          "title" => title, 
          "level" => Map.get(el, "level"),
          "speaker" => Map.get(el, "speaker"),
          "content" => Map.get(el, "content"),
          "time" => Map.get(el, "time"),
          "room" => Map.get(el, "room")
        } 
      end)
    
    talks = res 
      |> Enum.filter(fn(el) -> Map.get(el, "tutorial") == "talk" end)
      |> Enum.uniq_by(fn(el) -> Map.get(el, "id") end)
    talks_day_1 = talks
      |> Enum.filter(&(Map.get(&1, "conference_day") == "Conference day 1"))
      |> Enum.group_by(&(Map.get(&1, "time")))
    talks_day_2 = talks
      |> Enum.filter(&(Map.get(&1, "conference_day") == "Conference day 2"))
      |> Enum.group_by(&(Map.get(&1, "time")))
    
    tutorials = res 
      |> Enum.filter(fn(el) -> Map.get(el, "tutorial") == "tutorial" end)
      |> Enum.uniq_by(fn(el) -> Map.get(el, "id") end)
      |> Enum.group_by(&(Map.get(&1, "time")))

     talks_tutorials = res
      |> Enum.uniq_by(fn(el) -> Map.get(el, "id") end)

    state = %{
      "talks" => talks,
      "talks_day_1" => talks_day_1,
      "talks_day_2" => talks_day_2,
      "tutorials" => tutorials,
      "speakers" => speakers,
      "talks_tutorials" => talks_tutorials
    }

    Agent.start_link(fn() -> state end, name: :app_state)
  end

  def set(key, value) do
    Agent.update(:app_state, fn(state) -> Map.put(state, key, value) end)
  end

  def get(key) do
    Agent.get(:app_state, fn(state) -> Map.get(state, key) end)
  end
end