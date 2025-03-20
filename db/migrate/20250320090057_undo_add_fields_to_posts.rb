class UndoAddFieldsToPosts < ActiveRecord::Migration[7.2]
  def change
    remove_column :posts, :body
    remove_column :posts, :image
    remove_reference :posts, :user, foreign_key: true
  end
end
