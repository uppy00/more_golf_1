class PracticeRecord < ApplicationRecord
  has_many :posts, as: :postable, dependent: :destroy

  validates :driving_range_name, presence: true
  validates :practice_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :ball_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
