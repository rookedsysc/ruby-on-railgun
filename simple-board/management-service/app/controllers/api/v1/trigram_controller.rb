module Api
  module V1
    class TrigramController < ApplicationController
      before_action :set_taboo_word, only: [:update, :destroy]

      # GET /api/v1/trigram
      def index
        @trigram = TabooWord.all
        render json: @trigram, status: :ok
      end

      # POST /api/v1/trigram
      def create
        taboo_word = TabooWord.new(taboo_word_params)
        begin
          if taboo_word.save
            render json: taboo_word, status: :created
          else
            render json: { message: 'Failed to create taboo word', errors: taboo_word.errors.full_messages }, status: :unprocessable_entity
          end
        rescue ActiveRecord::RecordNotUnique
          render json: { message: 'Taboo word already exists' }, status: :not_acceptable
        end
      end

      # PUT /api/v1/trigram/:id
      def update
        if @taboo_word.update(taboo_word_params)
          render status: :ok
        else
          render json: { message: 'Failed to update taboo word', errors: @taboo_word.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/trigram/:id
      def destroy
        @taboo_word.destroy
        render json: { message: 'Taboo word deleted successfully' }, status: :ok
      end

      # GET /api/v1/trigram/trigram?query=단어
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

          thresh_hold = 0.3

          # word_similarity 함수는 전체 문자열에서 부분적으로 탐색하는 함수임
          # 근데 탐지율이 좋지 않아서 안씀
          # @similar_words = TabooWord.find_by_sql([<<-SQL, normalized_query, normalized_query, thresh_hold])
          #       SELECT trigram.id, trigram.content, word_similarity(trigram.content, ?) AS similarity_score
          #       FROM trigram
          #       WHERE word_similarity(trigram.content, ?) >= ?
          #       ORDER BY similarity_score DESC
          #       LIMIT 5
          # SQL

          @similar_words = TabooWord.find_by_sql([<<-SQL, normalized_combinations, thresh_hold])
                SELECT trigram.id, trigram.content, GREATEST(
                  #{normalized_combinations.map { |comb| "similarity(content, #{ActiveRecord::Base.connection.quote(comb)})" }.join(', ')}
                ) AS similarity_score
                FROM trigram
                WHERE trigram.content IN (
                  SELECT trigram.content
                  FROM UNNEST(ARRAY[?]::text[]) AS combination(word)
                  WHERE similarity(content, combination.word) >= ?
                )
                ORDER BY similarity_score DESC
                LIMIT 5
          SQL
          if @similar_words.any?
            render json: @similar_words.as_json(methods: :similarity_score), status: :ok
          else
            render json: { message: 'No similar taboo words found' }, status: :not_found
          end
        end
      end

      def grpc
        param = params[:query]
    
        # grpc 검증
        detections = []
        query = Levenshtein::Query.new(text: param)
        grpc_stub = Levenshtein::LevenshteinService::Stub.new('bad-word-detector-service:50051', :this_channel_is_insecure)
        response = grpc_stub.search(query)
    
        response.words.each do |word|
          detections << { id: word.id, content: word.content, similarity_rate: word.similarity_rate }
        end
    
        Rails.logger.info "[★] detections: #{detections.to_s}"
        render json: detections, status: :ok
      end

      # GET /api/v1/trigram/full_text?query=단어
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
        params.require(:trigram).permit(:content)
      end
    end
  end
end
