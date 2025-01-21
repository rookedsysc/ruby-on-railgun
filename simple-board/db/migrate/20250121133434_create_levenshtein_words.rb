class CreateLevenshteinWords < ActiveRecord::Migration[8.0]
  def change
    # fuzzystrmatch extension 설치
    enable_extension 'fuzzystrmatch'

    create_table :levenshtein_words do |t|
      t.string :content, null: false, unique: true
      t.timestamps
    end

    # 인덱스 설정
    add_index :levenshtein_words, :content, unique: true

    execute <<-SQL
      CREATE INDEX levenshtein_words_content_gin_idx
      ON levenshtein_words
      USING gin (content gin_trgm_ops);
    SQL
  end
end
