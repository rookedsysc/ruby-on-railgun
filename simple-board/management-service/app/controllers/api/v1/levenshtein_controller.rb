module Api
  module V1
    class LevenshteinController < ApplicationController
      def index
        @levenshtein_words = LevenshteinWords.all
        render json: @levenshtein_words, status: :ok
      end

      def create
        word = params[:content]

        if word.blank?
          render json: { message: 'Content parameter is missing' }, status: :unprocessable_entity
          return
        end

        levenshtein_word = LevenshteinWords.new(content: word)

        begin
          if levenshtein_word.save
            render json: { message: 'Word created successfully', word: levenshtein_word }, status: :created
          else
            render json: { message: 'Failed to create word', errors: levenshtein_word.errors.full_messages }, status: :bad_request
          end
        rescue ActiveRecord::RecordNotUnique
          render json: { message: 'Word already exists' }, status: :not_acceptable
        end
      end

      def update
        levenshtein_word = LevenshteinWords.find_by(id: params[:id])

        if levenshtein_word.nil?
          render json: { message: 'Word not found' }, status: :not_found
          return
        end

        new_content = params[:content]

        if new_content.blank?
          render json: { message: 'Content parameter is missing' }, status: :unprocessable_entity
          return
        end

        if levenshtein_word.update(content: new_content)
          render json: { message: 'Word updated successfully', word: levenshtein_word }, status: :ok
        else
          render json: { message: 'Failed to update word', errors: levenshtein_word.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        levenshtein_word = LevenshteinWords.find_by(id: params[:id])

        if levenshtein_word.nil?
          render json: { message: 'Word not found' }, status: :not_found
          return
        end

        if levenshtein_word.destroy
          render json: { message: 'Word deleted successfully' }, status: :ok
        else
          render json: { message: 'Failed to delete word', errors: levenshtein_word.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def search
        query = params[:query]

        if query.blank?
          render json: { message: 'Query parameter is missing' }, status: :unprocessable_entity
          return
        end

        normalized_query = query.gsub(/[^ㄱ-ㅎa-zA-Z가-힣]/, '')

        normalized_combinations = []
        (0...normalized_query.length).each do |i|
          (i...normalized_query.length).each do |j|
            normalized_combinations << normalized_query[i..j]
          end
        end

        # levenshtein.rb 거리 허용값
        thresh_hold = 0.5

        @similar_words = LevenshteinWords.find_by_sql([<<-SQL, normalized_combinations, thresh_hold])
          SELECT id, 
                 content, 
                 (1.0 - (
                   CAST(levenshtein(levenshtein_words.content, combination.word) AS FLOAT) / 
                   GREATEST(LENGTH(levenshtein_words.content), LENGTH(combination.word))
                 )) AS similarity_rate
          FROM levenshtein_words, UNNEST(ARRAY[?]::text[]) AS combination(word)
          WHERE (
            1.0 - (
              CAST(levenshtein(levenshtein_words.content, combination.word) AS FLOAT) / 
              GREATEST(LENGTH(levenshtein_words.content), LENGTH(combination.word))
            )
          ) >= ?
          ORDER BY similarity_rate DESC
          LIMIT 5
        SQL

        if @similar_words.any?
          render json: @similar_words, status: :ok
        else
          render json: { message: 'No similar taboo words found' }, status: :not_found
        end
      end
    end
  end
end
