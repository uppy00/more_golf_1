class GolfGear < ApplicationRecord
  belongs_to :user

  mount_uploader :club_image, GolfGearImageUploader 
  mount_uploader :driver_image, GolfGearImageUploader
  mount_uploader :iron_image, GolfGearImageUploader
  mount_uploader :wedge_image, GolfGearImageUploader
  mount_uploader :putter_image, GolfGearImageUploader
  mount_uploader :ball_image, GolfGearImageUploader
  mount_uploader :caddy_bag_image, GolfGearImageUploader
end
