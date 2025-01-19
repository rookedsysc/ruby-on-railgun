module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_post, only: %i[create index]

      # GET /api/v1/posts/:post_id/comments
      def index
        @comments = @post.comments
        render json: @comments
      end

      # POST /api/v1/posts/:post_id/comments
      def create
        @comment = @post.comments.new(comment_params)
        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/comments/:id
      def update
        comment = Comment.where(id: params[:id]).update(comment_params)
        render json: comment, status: :ok
      end

      # DELETE /api/v1/comments/:id
      def destroy
        Comment.delete_by(id: params[:id])
        render json: { message: 'Comment deleted' }, status: :ok
      end

      private

      def set_post
        @post = Post.find(params[:post_id])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
