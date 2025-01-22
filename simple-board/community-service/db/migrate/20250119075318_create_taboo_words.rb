class CreateTabooWords < ActiveRecord::Migration[8.0]
  def change
    create_table :taboo_words do |t|
      t.text :content

      t.timestamps
    end
  end
end
