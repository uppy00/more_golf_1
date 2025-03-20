class AddFieldsToPosts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :posts, :title, false
    add_column :posts, :body, :text
    add_column :posts, :image, :string
    add_reference :posts, :user, foreign_key: true
  end
end
