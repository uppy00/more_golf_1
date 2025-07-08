class CreateGolfGears < ActiveRecord::Migration[7.2]
  def change
    create_table :golf_gears do |t|
      t.references :user, null: false, foreign_key: true,  index: false
      t.string :club_image

      t.string :driver_brand
      t.string :driver_image

      t.string :iron_brand
      t.string :iron_image

      t.string :wedge_brand
      t.string :wedge_image

      t.string :putter_brand
      t.string :putter_image

      t.string :ball_brand
      t.string :ball_image

      t.string :caddy_bag_brand
      t.string :caddy_bag_image

      t.timestamps
    end
    add_index :golf_gears, :user_id, unique: true
  end
end
