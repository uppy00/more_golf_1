require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション' do
    it 'すべての属性が揃っていれば有効' do
      comment = build(:comment)
      expect(comment).to be_valid
    end

    it 'contentが空だと無効' do
      comment = build(:comment, body: "")
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include("を入力してください").or include("can't be blank")
    end

    it 'userが紐づいていなければ無効' do
      comment = build(:comment, user: nil)
      expect(comment).not_to be_valid
    end

    it 'postが紐づいていなければ無効' do
      comment = build(:comment, post: nil)
      expect(comment).not_to be_valid
    end
  end

  describe 'アソシエーション動作（削除の影響）' do
    let!(:comment) { create(:comment) }

    it 'ユーザー削除時にコメントも削除される' do
      expect { comment.user.destroy }.to change { Comment.count }.by(-1)
    end

    it '投稿削除時にコメントも削除される' do
      expect { comment.post.destroy }.to change { Comment.count }.by(-1)
    end
  end
end
