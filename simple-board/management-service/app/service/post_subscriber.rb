require Rails.root.join("config", "initializers", "rabbitmq")
require_relative "../protos/levenshtein_services_pb"

class PostSubscriber
  POST_QUEUE = "post".freeze

  def subscribe(channel)
    queue = channel.queue(POST_QUEUE, durable: true)

    Rails.logger.info " [*] Waiting for messages in #{queue.name}. To exit press CTRL+C"

    queue.subscribe do |delivery_info, properties, body|
      Rails.logger.info "delivery_info: #{delivery_info}" + " / properties: #{properties}" + " / body: #{body}"
      self.work(body)
    end
  end

  private

  def work(msg)
    post_id = msg.to_i
    post = Post.find(post_id)

    # grpc 검증
    detections = []
    grpc_stub = Levenshtein::LevenshteinService::Stub.new('bad-word-detector-service:50051', :this_channel_is_insecure)
    title_query = Levenshtein::Query.new(text: post.title)
    content_query = Levenshtein::Query.new(text: post.content)
    content_response = grpc_stub.search(content_query)
    title_response = grpc_stub.search(title_query)

    content_response.words.each do |word|
      detections << { id: word.id, content: word.content, similarity_rate: word.similarity_rate }
    end

    title_response.words.each do |word|
      detections << { id: word.id, content: word.content, similarity_rate: word.similarity_rate }
    end

    Rails.logger.info "[★] detections: #{detections.to_s}"

    if (detections.length > 0)
      post.update(is_visible: false)
    end
  end
end
