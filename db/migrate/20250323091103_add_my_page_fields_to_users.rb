class AddMyPageFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :nickname, :string
    add_column :users, :self_introduction, :text
    add_column :users, :favorite_course, :string
    add_column :users, :favorite_driving_range, :string
    add_column :users, :driving_range_type, :string
    add_column :users, :driving_range_price, :integer
    add_column :users, :best_score, :integer
    add_column :users, :best_score_course, :string
    add_column :users, :favorite_video_creator, :string
  end
end
