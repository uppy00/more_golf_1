class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  mount_uploader :image, PostImageUploader
  belongs_to :user
end
