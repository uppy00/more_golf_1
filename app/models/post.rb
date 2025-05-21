class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  # ransackで必要なもの
  def self.ransackable_attributes(auth_object = nil)
    [ "body", "title" ] # ここに検索可能な属性を指定
  end
  def self.ransackable_associations(auth_object = nil)
    [ "comments", "user" ] #  ここに関連付けを追加
  end
  # carrierwaveアップローダーを使うためのもの
  mount_uploader :image, PostImageUploader
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
end
