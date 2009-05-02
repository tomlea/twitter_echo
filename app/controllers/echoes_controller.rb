class EchoesController < ApplicationController
  def show
    @echo = Echo.find_by_username(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @echo }
    end
  end

  def new
    @echo = Echo.new(:username => screen_name)
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
      logger.debug( {:session => session}.inspect)
      redirect_to request_token.authorize_url
    end
  end

  def auth
    logger.debug( {:session => session}.inspect)

    logger.debug oauth_state.inspect
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

    respond_to do |format|
      if @echo.save
        flash[:notice] = 'Echo was successfully created.'
        format.html { redirect_to(@echo) }
        format.xml  { render :xml => @echo, :status => :created, :location => @echo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @echo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @echo = Echo.find_by_username(params[:id])
    @echo.destroy

    respond_to do |format|
      format.html { redirect_to(echo_url) }
      format.xml  { head :ok }
    end
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
    @screen_name ||= client.authorized? && client.info["screen_name"]
  end

  def oauth_state=(data)
    session[:oauth_state] = data
  end
end
