class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }, unless: :practice_record?

  def practice_record?
    tag&.name == "練習記録"
  end

  # ransackで必要なもの
  def self.ransackable_attributes(auth_object = nil)
    [ "body", "title", "tag_id" ] # ここに検索可能な属性を指定
  end
  def self.ransackable_associations(auth_object = nil)
    [ "comments", "user", "tag" ] #  ここに関連付けを追加
  end
  # carrierwaveアップローダーを使うためのもの
  mount_uploader :image, PostImageUploader
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :tag
  belongs_to :postable, polymorphic: true, optional: true

  accepts_nested_attributes_for :postable
end
