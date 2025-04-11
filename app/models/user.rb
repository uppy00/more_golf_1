class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] && password_confirmation.present? }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  # userのmypageのカラム↓
  validates :nickname, presence: true, length: { maximum: 20 }, uniqueness: true, unless: -> { new_record? }
  validates :self_introduction, length: { maximum: 200 }
  validates :favorite_course, length: { maximum: 20 }, allow_nil: true
  validates :favorite_driving_range, length: { maximum: 30 }, allow_nil: true
  validates :driving_range_type, inclusion: { in: [ "打ち放題", "球数", "インドア" ], allow_nil: true }
  validates :driving_range_price, numericality: { only_integer: true }, allow_nil: true
  validates :best_score, numericality: { only_integer: true }, allow_nil: true
  validates :best_score_course, length: { maximum: 100 }, allow_nil: true
  validates :favorite_video_creator, length: { maximum: 100 }, allow_nil: true

  has_many :posts, dependent: :destroy

  mount_uploader :avatar, AvatarUploader
  # own?メゾットで自分が投稿したものだけを識別
  def own?(object)
    id == object&.user_id
  end
end
