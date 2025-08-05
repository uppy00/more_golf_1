class Tag < ApplicationRecord
  has_many :posts

  validates :name, presence: true, uniqueness: true
    # ransackで必要なもの
    def self.ransackable_attributes(auth_object = nil)
      [ "id", "name", "created_at", "updated_at" ] # ここに検索可能な属性を指定
    end
    def self.ransackable_associations(auth_object = nil)
      [ "posts" ] #  ここに関連付けを追加
    end
end
