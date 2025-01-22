class AddTrigramIndexToTabooWords < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pg_trgm'
    add_index :taboo_words, :content, using: :gin, opclass: :gin_trgm_ops
  end
end
