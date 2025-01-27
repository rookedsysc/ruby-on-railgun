require "bunny"

module RabbitMQ
  class << self
    def connection
      @connection ||= Bunny.new('amqp://rabbitmq:5672')
    end

    def channel
      @channel ||= connection.start.create_channel
    end
  end
end
