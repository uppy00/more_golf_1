class ScoreRecord < ApplicationRecord
  has_many :posts, as: :postable, dependent: :destroy

  validates :course_name, presence: true
  # scoreは整数で0よりも大きい
  validates :score, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
