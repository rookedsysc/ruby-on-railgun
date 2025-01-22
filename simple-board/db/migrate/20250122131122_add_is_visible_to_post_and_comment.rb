class AddIsVisibleToPostAndComment < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :is_visible, :boolean, default: true, null: false
    add_column :comments, :is_visible, :boolean, default: true, null: false
    end
end
