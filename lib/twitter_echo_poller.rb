class TwitterEchoPoller < TwitterPoller
  attr_reader :echo
  def initialize(echo)
    super(echo.auth_details[:token], echo.auth_details[:secret])
    @echo = echo
  end

  def act
    @echo.reload
    p "Polling for #{@echo.inspect}"
    is_fast_forward = @echo.fast_forward?
    messages = client.messages
    messages.reverse.map{|m| [m["id"], m["sender_screen_name"], m["text"]] }.reverse.each do |id, user, message|
      client.update("@#{user} says '#{message}'") unless is_fast_forward or @echo.relayed?(id)
      @echo.relayed!(id)
    end
  end
end
