require_relative "../protos/levenshtein_services_pb"

class LevenshteinService < Levenshtein::LevenshteinService::Service
  def search(query, _unused_call)
    normalized_query = query.text.gsub(/[^ㄱ-ㅎa-zA-Z가-힣]/, "")
    normalized_query = reduce_repeated_chars(normalized_query)
    normalized_query += "  " # 마지막에 욕 쓰는 경우 있어서 공백 추가

    normalized_combinations = []
    if normalized_query.length < 5
      normalized_combinations = [ normalized_query ]
    else
      normalized_combinations = normalized_query.chars.each_cons(4).map(&:join)
    end

    Rails.logger.info "[✨] RPC 메서드 호출됨"

    thresh_hold = 0.3

    begin
      # Levenshtein distance를 계산하여 similarity_rate를 계산하는 방법
      # similar_words = LevenshteinWords.find_by_sql([<<-SQL, normalized_combinations, thresh_hold])
      #   SELECT id,
      #          content,
      #          (1.0 - (
      #            CAST(levenshtein(levenshtein_words.content, combination.word) AS FLOAT) /
      #            GREATEST(LENGTH(levenshtein_words.content), LENGTH(combination.word))
      #          )) AS similarity_rate
      #   FROM levenshtein_words, UNNEST(ARRAY[?]::text[]) AS combination(word)
      #   WHERE (
      #     1.0 - (
      #       CAST(levenshtein(levenshtein_words.content, combination.word) AS FLOAT) /
      #       GREATEST(LENGTH(levenshtein_words.content), LENGTH(combination.word))
      #     )
      #   ) >= ?
      #   ORDER BY similarity_rate DESC
      #   LIMIT 5
      # SQL

      # trigram을 이용하여 similarity를 계산하는 방법
      similar_words = TabooWord.find_by_sql([ <<-SQL, normalized_combinations, thresh_hold ])
        SELECT taboo_words.id, taboo_words.content, GREATEST(
          #{normalized_combinations.map { |comb| "similarity(content, #{ActiveRecord::Base.connection.quote(comb)})" }.join(', ')}
        ) AS similarity_score
        FROM taboo_words
        WHERE taboo_words.content IN (
          SELECT taboo_words.content
          FROM UNNEST(ARRAY[?]::text[]) AS combination(word)
          WHERE similarity(content, combination.word) >= ?
        )
        ORDER BY similarity_score DESC
        LIMIT 5
      SQL
      Rails.logger.info "[✨] similar words : #{similar_words}"

      if similar_words.nil?
        return Levenshtein::SearchResponse.new(words: [])
      end

      response = Levenshtein::SearchResponse.new(
        words: similar_words.map do |word|
          Levenshtein::Word.new(
            id: word.id,
            content: word.content,
            similarity_rate: word.similarity_score
          )
        end
      )
      response
    rescue => e
      Rails.logger.error "[🔥] 에러 발생 : #{e}"
      e
    end
  end

  private

  def reduce_repeated_chars(input)
    input.gsub(/(.)\1+/, '\1')
  end
end
