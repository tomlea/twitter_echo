class TwitterPoller
  include Comparable
  MARGIN_FOR_ERROR = 50
  attr_reader :next_poll, :client

  def initialize(token, secret)
    @client = TwitterOAuth::Client.new(
        :consumer_key => 'xZr8BIsVcTEimDONAjblBw',
        :consumer_secret => '5Ky01eWgMj0IeYqPqHK8gbVJ2SsWYycmso14zjwGY4',
        :token => token,
        :secret => secret
    )
    calculate_next_poll
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
      remaining_hits = rate_limit_status["remaining_hits"].to_i - MARGIN_FOR_ERROR
      reset_time_in_seconds = rate_limit_status["reset_time_in_seconds"].to_i
      remaining_seconds = (Time.at(reset_time_in_seconds) - Time.now).to_i

      if remaining_hits <= 0
        @next_poll = Time.at(reset_time_in_seconds)
      else
        @next_poll = (remaining_seconds/remaining_hits).ceil.seconds.from_now
      end
    rescue
      @next_poll = 60.seconds.from_now
      raise
    end
  end

  def <=>(other)
    next_poll <=> other.next_poll
  end
end
