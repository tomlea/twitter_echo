class TwitterEchoPoller < TwitterPoller
  def initialize(echo)
    super(echo.auth_details.token, echo.auth_details.secret)
    @echo = echo
  end

  def run
    echo.reload
    client.messages(:received).map{|m| [m.id, m.sender.screen_name, m.text] }.reverse.each do |id, user, message|
      # client.status(:post, "#{message} [@#{user}]") unless echo.relayed?(id)
      handled_messages << id
    end
  end
end
