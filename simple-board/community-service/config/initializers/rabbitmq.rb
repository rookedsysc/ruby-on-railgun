require "bunny"

module RabbitMQ
  class << self
    def connection
      @connection ||= Bunny.new(host: "rabbitmq", port: 5672, username: "user", password: "password")
    end

    def channel
      @channel ||= connection.start.create_channel
    end
  end
end
