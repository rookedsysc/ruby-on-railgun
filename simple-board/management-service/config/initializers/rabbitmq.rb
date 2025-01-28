require "bunny"
require_relative "../../app/service/post_subscriber"

class RabbitMQ
  def initialize
    @connection ||= Bunny.new(host: "rabbitmq", port: 5672, username: "user", password: "password", automatically_recover: true)
  end

  def channel
    @channel ||= @connection.start.create_channel
  end
end

Thread.new do
  rabbitmq = RabbitMQ.new
  post_subscriber = PostSubscriber.new
  post_subscriber.subscribe(rabbitmq.channel)
end
