class TwitterPollerCollection < Array
  def each_poll(&block)
    @each_poll ||= []
    if block_given?
      @each_poll << Proc.new(&block)
    else
      @each_poll.each do |proc|
        begin
          proc.call(self)
        rescue => e
          puts "#{e.class}: #{e.message}"
          e.backtrace.each{|l| puts " "*8 + l}
        end
      end
    end
  end

  def start_polling
    while true
      each_poll

      if empty?
        sleep 10
        next
      end

      sort!

      if (sleep_time = (first.next_poll - Time.now).to_i) > 0
        sleep(sleep_time)
        next
      end

      first.poll
    end
  end
end
