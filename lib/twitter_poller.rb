class TwitterPoller
  MARGIN_FOR_ERROR = 50
  attr_reader :next_poll, :client

  def initialize(token, secret)
    @client = TwitterOAuth::Client.new(
        :consumer_key => 'xZr8BIsVcTEimDONAjblBw',
        :consumer_secret => '5Ky01eWgMj0IeYqPqHK8gbVJ2SsWYycmso14zjwGY4',
        :token => token,
        :secret => secret
    )
  end

  def poll
    act if respond_to? :act
    @last_error = nil
  rescue => e
    unless @last_error.class == e.class
      @last_error = e
      log_error(e)
      nil
    end
  ensure
    calculate_next_poll
  end

  def log_error(e)
    STDERR.puts("#{e.class.name}: #{e.message}")
    e.backtrace.each{|l| STDERR.puts "  " + l }
  end

  def calculate_next_poll
    begin
      rate_limit_status = client.rate_limit_status
      remaining_hits = rate_limit_status["remaining-hits"].to_i - MARGIN_FOR_ERROR
      reset_time_in_seconds = rate_limit_status["reset-time-in-seconds"].to_f

      if remaining_hits == 0
        @next_poll = reset_time_in_seconds.seconds.from_now
      else
        @next_poll = (reset_time_in_seconds/remaining_hits).ceil.seconds.from_now
      end
    rescue
      @next_poll = 60.seconds.from_now
      raise
    end
  end
end
