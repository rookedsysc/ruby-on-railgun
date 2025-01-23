require "grpc"
require_relative "../../app/service/levenshtein_service"

server = nil

Thread.new do
  server = GRPC::RpcServer.new
  server.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  server.handle(LevenshteinService)
  Rails.logger.info 'gRPC Server running on 0.0.0.0:50051'
  server.run_till_terminated
end

at_exit do
  if server
    Rails.logger.info 'Shutting down gRPC Server...'
    server.stop
  end
end
