class TwitterPollerCollection < Array
  def start_polling
    while true
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
