module Api
  module V1
    class TabooWordsController < ApplicationController
      before_action :set_taboo_word, only: [:update, :destroy]

      # GET /api/v1/taboo_words
      def index
        @taboo_words = TabooWord.all
        render json: @taboo_words, status: :ok
      end

      # POST /api/v1/taboo_words
      def create
        taboo_word = TabooWord.new(taboo_word_params)
        if taboo_word.save
          render json: @taboo_word, status: :created
        else
          render json: { message: 'Failed to create taboo word', errors: taboo_word.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/taboo_words/:id
      def update
        if @taboo_word.update(taboo_word_params)
          render status: :ok
        else
          render json: { message: 'Failed to update taboo word', errors: @taboo_word.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/taboo_words/:id
      def destroy
        @taboo_word.destroy
        render json: { message: 'Taboo word deleted successfully' }, status: :ok
      end

      private

      # Find TabooWord by ID
      def set_taboo_word
        @taboo_word = TabooWord.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Taboo word not found' }, status: :not_found
      end

      # Strong parameters
      def taboo_word_params
        params.require(:taboo_word).permit(:content)
      end
    end
  end
end
