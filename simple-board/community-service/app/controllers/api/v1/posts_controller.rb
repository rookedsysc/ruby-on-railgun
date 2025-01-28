require_dependency Rails.root.join("app/services/rabbit_mq_publisher")

module Api
  module V1
    class PostsController < ApplicationController
      QUEUE_NAME = "post".freeze
      # update, show, destroy 메서드가 실행되기 전에 set_post 메서드를 실행함
      # set_post 메서드는 id를 통해 Post를 찾아 @post에 할당함
      before_action :set_post, only: %i[show update destroy]

      # GET /api/v1/posts
      def index
        @posts = Post.find_by(is_visible: true)
        render json: @posts
      end

      # GET /api/v1/posts/:id
      def show
        render json: @post
      end

      # POST /api/v1/posts
      def create
        @post = Post.new(post_params)
        if @post.save
          RabbitMQPublisher.publish(QUEUE_NAME, @post.id.to_s)
          render json: @post, status: :created
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/posts/:id
      def update
        if @post.update(post_params)
          RabbitMQPublisher.publish(QUEUE_NAME, @post.id.to_s)
          render json: @post
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/posts/:id
      def destroy
        @post.destroy
        head :no_content
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :content)
      end
    end
  end
end
