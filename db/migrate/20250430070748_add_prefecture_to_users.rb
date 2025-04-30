class AddPrefectureToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :prefecture_id, :integer
  end
end
