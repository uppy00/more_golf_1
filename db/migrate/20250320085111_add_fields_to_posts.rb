class AddFieldsToPosts < ActiveRecord::Migration[7.2]
  def change
    add_reference :posts, :user, null: false, foreign_key: true # user_idカラム（外部キー制約付き）
    change_column_null :posts, :title, false # titleカラムにnull: false
    add_column :posts, :body, :text # bodyカラムを追加（text型）
    add_column :posts, :image, :string # imageカラムを追加（string型）
  end
end
