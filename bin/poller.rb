#!/usr/bin/env ruby
require "logger"
RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)

require File.dirname(__FILE__) + '/../config/environment'

require 'drb'
require 'daemons'

module EndPoint
  def start
    @collection = TwitterPollerCollection.new()
    Echo.all.each do |echo|
      @collection << TwitterEchoPoller.new(echo)
    end
    @queue = Queue.new
    @collection.each_poll do |collection|
      unless @queue.empty?
        id = @queue.shift
        collection << TwitterEchoPoller.new(Echo.find(id))
      end
    end
    @collection.start_polling
  end

  def add(id)
    del(id)
    @queue.push(id)
  end

  def del(id)
    @collection.delete_if{|ep| ep.echo.id == id }
  end

  extend self
end

pids_path = File.join(File.dirname(__FILE__), *%w[.. tmp pids])
FileUtils.mkdir_p pids_path
Daemons.run_proc('poller.rb', {:dir_mode => :normal, :dir => pids_path}) do
  DRb.start_service "druby://localhost:59557", EndPoint
  EndPoint.start
end
