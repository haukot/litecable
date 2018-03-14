# frozen_string_literal: true

module LiteCable
  # Rack middleware to hijack sockets.
  #
  # Uses thread-per-connection model (thus recommended only for development and test usage).
  #
  # Inspired by https://github.com/ngauthier/tubesock/blob/master/lib/tubesock.rb
  module Server
    # FIXME 'websocket' should be in gemspec by default - because whole
    # litecable can't run without it
    require "websocket"
    require "lite_cable/server/subscribers_map"
    require "lite_cable/server/client_socket"
    require "lite_cable/server/heart_beat"
    require "lite_cable/server/middleware"

    class << self
      attr_accessor :subscribers_map

      # Broadcast encoded message to the stream
      def broadcast(stream, message, coder: nil)
        coder ||= LiteCable.config.coder
        subscribers_map.broadcast stream, message, coder
      end
    end

    self.subscribers_map = SubscribersMap.new
  end
end
