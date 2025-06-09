class AddVideoToPost < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :video, :string
  end
end
