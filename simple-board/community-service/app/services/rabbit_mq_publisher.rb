require Rails.root.join("config", "initializers", "rabbitmq")

class RabbitMQPublisher
  def self.publish(queue, message)
    channel = RabbitMQ.channel
    queue = channel.queue(queue, durable: true) # durable: true는 RabbitMQ가 죽어도 큐가 유지되도록 함
    channel.default_exchange.publish(message, routing_key: queue.name)
  end
end
