defmodule App.Commands do
  use App.Router
  use App.Commander

  alias App.Commands.Bot

  command "help", Bot, :help
  command "schedule", Bot, :schedule
  command "talk", Bot, :talk
  command "speakers", Bot, :speakers
  command "speaker", Bot, :speaker

  callback_query_command "schedule", Bot, :schedule_callback
  
  inline_query_command "talk", Bot, :talk_query
  inline_query_command "speaker", Bot, :speaker_query

  # Fallbacks

  # Rescues any unmatched callback query.
  callback_query do
    Logger.log :warn, "Did not match any callback query"

    answer_callback_query text: "Sorry, but there is no JoJo better than Joseph."
  end

  # Rescues any unmatched inline query.
  inline_query do
    Logger.log :warn, "Did not match any inline query"
  end

  # The `message` macro must come at the end since it matches anything.
  # You may use it as a fallback.
  message do
    Logger.log :warn, "Did not match the message"

    send_message "Sorry, I couldn't understand you"
  end
end
