require 'grpc'
require 'profanity_services_pb'

module Api
  module V1
    class TabooWordsController < ApplicationController
      def detect_profanity
        query = params[:text]

        if query.blank?
          render json: { message: 'Text parameter is missing' }, status: :unprocessable_entity
          return
        end

        begin
          grpc_client = Profanity::ProfanityService::Stub.new('korcen-profanity:50051', :this_channel_is_insecure)
          request = Profanity::TextRequest.new(text: query)
          response = grpc_client.detect_profanity(request)

          render json: { text: query, is_profane: response.is_profane, message: response.message }, status: :ok
        rescue GRPC::BadStatus => e
          render json: { message: 'Failed to communicate with gRPC server', error: e.message }, status: :internal_server_error
        end
      end
    end
  end
end
