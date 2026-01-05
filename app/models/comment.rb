class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 200 }

  belongs_to :user
  belongs_to :post
  #　通知機能に関するもの
  has_many :notifications, dependent: :destroy
end
