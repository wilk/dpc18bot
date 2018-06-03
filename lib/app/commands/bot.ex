defmodule App.Commands.Bot do
  use App.Commander

  alias App.State

  # display all available commands
  def help(update) do
    Logger.info("Command /help")

    send_message """
    List of all available commands:

    - /schedule: list all available talks and tutorials
    - @dpc18bot /talk: display the detail of a given talk/tutorial
    - /speakers: list all available speakers
    - @dpc18bot /speaker: display the detail of a given speaker
    - @dpc18bot /attend: bookmark the given talk/tutorial
    - @dpc18bot /unattend: unbookmark the given talk/tutorial
    - /bookmarks: list you bookmarks
    """
  end

  # display 3 action buttons (2 days and the tutorials day)
  def schedule(update) do
    Logger.info("Command /schedule")

    options = [
      [
        %{
          text: "Day 1",
          callback_data: "/schedule day1"
        },
        %{
          text: "Day 2",
          callback_data: "/schedule day2"
        }
      ],
      [
        %{
          text: "Tutorial day",
          callback_data: "/schedule tutorial"
        }
      ]
    ]

    markup = %{
      inline_keyboard: options
    }

    send_message "Which day?", reply_markup: markup
  end

  # common schedule function, useful both for tuts and talks
  defp build_schedule_answer(talks) do
    talks
      |> Map.keys()
      |> Enum.map_join("\n\n", fn(time) ->
        msg = Map.get(talks, time) |> Enum.map_join("\n", &("#{Map.get(&1, "title")} (#{Map.get(&1, "speaker")}) | #{Map.get(&1, "room")} | #{Map.get(&1, "level")}"))
        "*#{time}*\n\n#{msg}"
      end)
  end

  # display the talks list for the selected day
  def schedule_callback(update) do
    Logger.info("Callback Query Command /schedule")

    case update.callback_query.data do
      "/schedule tutorial" -> 
        Logger.info("Callback Query Command /schedule tutorial")

        message = State.get("tutorials") |> build_schedule_answer()
        send_message("*Schedule of Tutorials day*\n\n#{message}", parse_mode: "Markdown")

      "/schedule day1" -> 
        Logger.info("Callback Query Command /schedule day1")

        message = State.get("talks_day_1") |> build_schedule_answer()
        send_message("*Schedule of Conference day 1*\n#{message}", parse_mode: "Markdown")

      "/schedule day2" -> 
        Logger.info("Callback Query Command /schedule day2")

        message = State.get("talks_day_2") |> build_schedule_answer()
        send_message("*Schedule of Conference day 2*\n#{message}", parse_mode: "Markdown")
    end
  end

  # display inline talks to choose
  def talk_query(update) do
    Logger.info("Inline Query Command /talk")

    query = update.inline_query.query |> String.replace("/talk ", "") |> String.downcase()
    schedule = State.get("schedule")

    schedule
      |> Enum.filter(&(String.contains?(Map.get(&1, "title_lower"), query)))
      |> Enum.map(fn(talk) ->
        title = Map.get(talk, "title")

        %InlineQueryResult.Article{
          id: Map.get(talk, "id"),
          title: title,
          input_message_content: %{
            message_text: "/talk #{title}"
          }
        }
      end)
      |> answer_inline_query()
  end

  # display details about the choosen talk
  def talk(update) do
    Logger.info("Command /talk")

    query = update.message.text |> String.replace("/talk ", "")
    schedule = State.get("schedule")

    schedule
      |> Enum.filter(&(Map.get(&1, "title") == query))
      |> Enum.map_join("\n", &(
        """
        *#{Map.get(&1, "title")} (#{Map.get(&1, "speaker")} | #{Map.get(&1, "time")} | #{Map.get(&1, "room")})*
        #{Map.get(&1, "content")}
        """
      ))
      |> send_message(parse_mode: "Markdown")
  end

  # display speakers list
  def speakers(update) do
    Logger.info("Command /speakers")

    message = State.get("speakers")
      |> Enum.map_join("\n", &(Map.get(&1, "name")))
    
    send_message("*Speakers list*\n\n#{message}", parse_mode: "Markdown")
  end

  # display inline speakers to choose
  def speaker_query(update) do
    Logger.info("Inline Command Query /speaker")

    query = update.inline_query.query |> String.replace("/speaker ", "") |> String.downcase()
    speakers = State.get("speakers")

    speakers
      |> Enum.filter(&(String.contains?(Map.get(&1, "lower_name"), query)))
      |> Enum.map(fn(talk) ->
        name = Map.get(talk, "name")

        %InlineQueryResult.Article{
          id: name,
          title: name,
          input_message_content: %{
            message_text: "/speaker #{name}"
          }
        }
      end)
      |> answer_inline_query()
  end

  # display details of a choosen speaker
  # hint: display *#{name}\n* #{bio}
  def speaker(update) do
    Logger.info("Command /speaker")

    query = update.message.text |> String.replace("/speaker ", "")
    speakers = State.get("speakers")

    speakers
      |> Enum.filter(&(Map.get(&1, "name") == query))
      |> Enum.map_join("\n", &(
        """
        *#{Map.get(&1, "name")}*
        #{Map.get(&1, "bio")}
        """
      ))
      |> send_message(parse_mode: "Markdown")
  end

  # todo: display your bookmarks
  # hint: fetch bookmarks from Bookmarks
  # hint: cut'n'paste from speakers/schedule?
  def bookmark(update) do
  end

  # todo: display inline talks to choose
  # hint: cut'n'paste from speaker_query/talk_query?
  def attend_query(update) do
  end

  # todo: add the choosen talk to your bookmarks
  # hint: use Bookmarks to add a new talk
  def attend(update) do
  end

  # todo: display inline bookmarks to choose
  # hint: cut'n'paste from attend?
  def unattend_query(update) do
  end

  # todo: remove the choosen talk from your bookmarks
  # hint: use Bookmarks to remove an existing talk
  def unattend(update) do
  end
end
