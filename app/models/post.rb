class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }, unless: :practice_record?
  validate :only_one_media
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
  # 通知機能に関するもの
  # いいね通知
  def create_notification_like!(current_user)
    #　自分の投稿に自分のいいね通知が来ないようにする
    return if user_id == current_user.id
    Notification.find_or_create_by!(
      visitor_id: current_user.id,
      visited_id: user_id,
      post_id: id,
      action: "like"
    )
  end
  # コメント通知
  def create_notification_comment!(current_user, comment)
    #　自分の投稿に自分のコメント通知が来ないようにする
    return if user_id == current_user.id
    Notification.create!(
      visitor_id: current_user.id,
      visited_id: user_id,
      post_id: id,
      comment_id: comment.id,
      action: "comment",
      checked: false
    )
    
  end
  # carrierwaveアップローダーを使うためのもの
  mount_uploader :image, PostImageUploader
  mount_uploader :video, VideoUploaderUploader
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :tag
  # polymophicに伴うもの
  belongs_to :postable, polymorphic: true, optional: true
  accepts_nested_attributes_for :postable
  # 通知機能に伴うもの
  has_many :notifications, dependent: :destroy

  private
  # 動画または画像のみを表示させるもの
  def only_one_media
    if image.present? && video.present?
      errors.add(:base, "画像または動画どちらかのみをアップロードしてください")
    end
    # 画像も動画も空でもOKなので、空のチェックは不要にする
  end
end
