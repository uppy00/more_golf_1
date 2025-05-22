class AddTagRefToPosts < ActiveRecord::Migration[7.2]
  def change
    add_reference :posts, :tag, null: true, foreign_key: true
  end
end
