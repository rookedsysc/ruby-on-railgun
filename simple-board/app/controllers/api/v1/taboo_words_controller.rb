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
          render json: taboo_word, status: :created
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

      # GET /api/v1/taboo_words/trigram?query=단어
      def trigram
        query = params[:query]

        if query.blank?
          render json: { message: 'Query parameter is missing' }, status: :unprocessable_entity
        else
          # 소녀가 금기어일 경우 소ㅁ녀는 탐지가 되는데 소a녀는 탐지가 안됨 -> ㄱ~ㅎ이 빠져서 그럼
          normalized_query = query.gsub(/[^ㄱ-ㅎa-zA-Z가-힣]/, '')
          normalized_combinations = []

          for i in 0...normalized_query.length do
            for j in i...normalized_query.length do
              normalized_combinations << normalized_query[i..j]
            end
          end

          # @similar_words = TabooWord
          #                    .where("content % ?", normalized_query)
          #                    .select("taboo_words.*, similarity(content, #{ActiveRecord::Base.connection.quote(normalized_query)}) AS similarity_score")
          #                    .order(Arel.sql("similarity_score DESC"))
          #                    .limit(5)

          @similar_words = TabooWord
                             .where("content IN (?) OR content % ?", normalized_combinations, normalized_query)
                             .select("taboo_words.*, GREATEST(#{normalized_combinations.map { |query| "similarity(content, #{ActiveRecord::Base.connection.quote(query)})" }.join(', ')}) AS similarity_score")
                             .order(Arel.sql("similarity_score DESC"))
                             .limit(5)

          if @similar_words.any?
            render json: @similar_words.as_json(methods: :similarity_score), status: :ok
          else
            render json: { message: 'No similar taboo words found' }, status: :not_found
          end
        end
      end

      # GET /api/v1/taboo_words/full_text?query=단어
      def full_text
        query = params[:query]

        if query.blank?
          render json: { message: 'Query parameter is missing' }, status: :unprocessable_entity
        else
          normalized_query = query.gsub(/[^ㄱ-ㅎa-zA-Z가-힣]/, '')
          normalized_combinations = []

          for i in 0...normalized_query.length do
            for j in i...normalized_query.length do
              normalized_combinations << normalized_query[i..j]
            end
          end

          @similar_words = TabooWord.where(content: normalized_combinations)
        end

        if @similar_words.any?
          render json: @similar_words, status: :ok
        else
          render json: { message: 'No similar taboo words found' }, status: :not_found
        end
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
