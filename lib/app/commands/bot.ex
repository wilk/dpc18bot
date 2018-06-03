defmodule App.Commands.Bot do
  use App.Commander

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

  # todo: display 3 action buttons (2 days and the tutorials day)
  # hint: use reply_markup{inline_keyboard[[{text, callback_data}]]}
  def schedule(update) do
    Logger.info("Command /schedule")

    options = [
      [],
      []
    ]

    markup = %{
    
    }

    send_message "Which day?", reply_markup: markup
  end

  # todo: display the talks list for the selected day
  def schedule_callback(update) do
    Logger.info("Callback Query Command /schedule")

    case update.callback_query.data do
      "/schedule tutorial" -> 
        Logger.info("Callback Query Command /schedule tutorial")
        # hint: fetch tutorial from State tutorials
        # hint: tutorials are grouped by hours (Map.keys)
        # hint: #{title} (#{speaker}) | #{room} | #{level}

      "/schedule day1" -> 
        Logger.info("Callback Query Command /schedule day1")
        # hint: fetch talks from State talks_day_1
        # hint: tutorials are grouped by hours (Map.keys)
        # hint: #{title} (#{speaker}) | #{room} | #{level}

      "/schedule day2" -> 
        Logger.info("Callback Query Command /schedule day2")
        # hint: fetch talks from State talks_day_1
        # hint: tutorials are grouped by hours (Map.keys)
        # hint: #{title} (#{speaker}) | #{room} | #{level}
    end
  end

  # todo: display inline talks to choose
  # hint: fetch schedule from State
  # hint: sanitize update.inline_query.query from /talk command
  # hint: reply with answer_inline_query and %InlineQueryResult.Article struct (id, title, input_message_content%{message_text})
  def talk_query(update) do
    Logger.info("Inline Query Command /talk")
  end

  # todo: display details about the choosen talk
  # hint: get talks from State schedule
  # hint: santize update.message.text from /talk command
  # hint: reply with send_message *#{title} (#{speaker} | #{time} | #{room})*\n#/{content}
  def talk(update) do
    Logger.info("Command /talk")
  end
end
