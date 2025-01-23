require_relative "../protos/levenshtein_services_pb"

class LevenshteinService < Levenshtein::LevenshteinService::Service
  def search(query, _unused_call)
    normalized_query = query.text.gsub(/[^ㄱ-ㅎa-zA-Z가-힣]/, "")

    normalized_combinations = []
    (0...normalized_query.length).each do |i|
      (i...normalized_query.length).each do |j|
        normalized_combinations << normalized_query[i..j]
      end
    end

    thresh_hold = 0.5
    similar_words = LevenshteinWords.find_by_sql([<<-SQL, normalized_combinations, thresh_hold])
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

    response = Levenshtein::SearchResponse.new(
      words: similar_words.map do |word|
        Levenshtein::Word.new(
          id: word.id,
          content: word.content,
          similarity_rate: word.similarity_rate
        )
      end
    )

    response
  end
end
