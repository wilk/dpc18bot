defmodule App.Commands.Bot do
  # Notice that here we just `use` Commander. Router is only
  # used to map commands to actions. It's best to keep routing
  # only in App.Commands file. Commander gives us helpful
  # macros to deal with Nadia functions.
  use App.Commander

  # Functions must have as first parameter a variable named
  # update. Otherwise, macros (like `send_message`) will not
  # work as expected.
  # todo:
  # hint: use send_message with parse_mode Markdown
  def help(update) do
    Logger.info "Command /help"
  end
end
