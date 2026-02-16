class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :visitor, null: false, foreign_key: { to_table: :users }
      t.references :visited, null: false, foreign_key: { to_table: :users }

      t.references :post, null: false, foreign_key: true
      t.references :comment, foreign_key: true

      t.string :action, null: false, default: ""
      t.boolean :checked, null: false, default: false

      t.timestamps
    end

    add_index :notifications, :checked
    add_index :notifications, :action
    add_index :notifications, [ :visited_id, :checked ] # 未読取得が速い

    # いいね通知だけ重複防止
    add_index :notifications, [ :visitor_id, :visited_id, :post_id, :action ],
              unique: true,
              where: "action = 'like'",
              name: "index_notifications_unique_like"
  end
end
