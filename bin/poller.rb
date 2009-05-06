#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'

require 'drb'

module EndPoint
  def start
    @collection = TwitterPollerCollection.new()
    Echo.all.each do |echo|
      @collection << TwitterEchoPoller.new(echo)
    end
    @collection.start_polling
  end

  def add(id)
    del(id)
    @collection << TwitterEchoPoller.new(Echo.find(id))
    p "Adding #{id}"
  end

  def del(id)
    echo = Echo.find(id)
    @collection.delete_if{|ep| ep.echo == echo }
    p "Deling #{id}"
  end

  extend self
end

DRb.start_service "druby://localhost:59557", EndPoint
EndPoint.start

