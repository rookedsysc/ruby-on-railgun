class AddUniqueConstraintToTabooWordsContent < ActiveRecord::Migration[8.0]
  def change
    # taboo_words 테이블의 content 컬럼에 unique index 적용
    add_index :taboo_words, :content, unique: true, name: 'index_taboo_words_on_content_unique'
  end
end
