require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe 'バリデーション' do
    it '有効なlikeである' do
      like = build(:like, user: user, post: post)
      expect(like).to be_valid
    end

    it '同じユーザーが同じ投稿に2回いいねすると無効' do
      create(:like, user: user, post: post)
      duplicate_like = build(:like, user: user, post: post)
      expect(duplicate_like).not_to be_valid
      expect(duplicate_like.errors[:user_id]).to include("はすでに存在します").or include("has already been taken")
    end
  end

  describe 'アソシエーション' do
    it 'userとの関連付けがある' do
      like = create(:like)
      expect(like.user).to be_a(User)
    end

    it 'postとの関連付けがある' do
      like = create(:like)
      expect(like.post).to be_a(Post)
    end
  end
end
