class CreateLevenshteinWords < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'fuzzystrmatch'

    create_table :levenshtein_words do |t|
      t.string :content, null: false
      t.timestamps
    end

    add_index :levenshtein_words, :content, unique: true
  end
end
