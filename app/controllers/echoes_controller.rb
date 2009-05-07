class EchoesController < ApplicationController
  def index
    if client.authorized?
      if @echo = Echo.find_by_username(screen_name)
        redirect_to @echo
      else
        redirect_to new_echo_path
      end
    end
  end

  def show
    @echo = Echo.find_by_username(params[:id])
  end

  def new
    @echo = Echo.new(:username => screen_name)
  end

  def forget_me
    self.oauth_state = {}
    redirect_to root_path
  end

  def begin_auth
    if client.authorized?
      if @echo = Echo.find_by_username(screen_name)
        redirect_to @echo
      else
        redirect_to new_echo_path
      end
    else
      request_token = client.request_token
      self.oauth_state = {:request_token => request_token.token, :request_secret => request_token.secret}
      redirect_to request_token.authorize_url
    end
  end

  def auth
    access_token = client.authorize(oauth_state[:request_token], oauth_state[:request_secret])
    self.oauth_state = {:token => access_token.token, :secret => access_token.secret}

    if @echo = Echo.find_by_username(screen_name)
      redirect_to @echo
    else
      redirect_to new_echo_path
    end
  end

  def create
    @echo = Echo.new(:username => screen_name, :auth_details => oauth_state.slice(:secret, :token))

    if @echo.save
      redirect_to(@echo)
    else
      render :action => "new"
    end
  end

  def destroy
    @echo = Echo.find_by_username(params[:id])
    @echo.destroy

    redirect_to(new_echo_url)
  end

private
  def oauth_state
    session[:oauth_state] ||= {}
    session[:oauth_state]
  end

  def client
    begin
      if oauth_state.slice(:token, :secret).any?
        @client ||= TwitterOAuth::Client.new(
            :consumer_key => 'xZr8BIsVcTEimDONAjblBw',
            :consumer_secret => '5Ky01eWgMj0IeYqPqHK8gbVJ2SsWYycmso14zjwGY4',
            :token => oauth_state[:token],
            :secret => oauth_state[:secret]
        )
      end
    rescue OAuth::Unauthorized
    end
    @client ||= TwitterOAuth::Client.new(:consumer_key => 'xZr8BIsVcTEimDONAjblBw', :consumer_secret => '5Ky01eWgMj0IeYqPqHK8gbVJ2SsWYycmso14zjwGY4')
  end

  def screen_name
    Timeout::timeout(5) do
      @screen_name ||= client.authorized? && client.info["screen_name"]
    end
  rescue Timeout::Error
    raise TwitterTimeout, "Twitter was too slow when getting the username."
  end

  def oauth_state=(data)
    session[:oauth_state] = data
  end
end
