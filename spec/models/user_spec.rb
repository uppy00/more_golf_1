require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'バリデーション' do
    context 'first_name' do
      it 'が空なら無効' do
        user.first_name = nil
        expect(user).to be_invalid
        expect(user.errors[:first_name]).to include('を入力してください')
      end
    end

    context 'last_name' do
      it 'が空なら無効' do
        user.last_name = nil
        expect(user).to be_invalid
      end
    end

    context 'email' do
      it 'が空なら無効' do
        user.email = nil
        expect(user).to be_invalid
      end

      it 'が重複していると無効' do
        create(:user, email: 'duplicate@example.com')
        user.email = 'duplicate@example.com'
        expect(user).to be_invalid
      end
    end

    context 'password' do
      it 'が3文字未満だと無効' do
        user.password = user.password_confirmation = 'ab'
        expect(user).to be_invalid
      end

      it 'とconfirmationが一致しなければ無効' do
        user.password = 'password'
        user.password_confirmation = 'notmatch'
        expect(user).to be_invalid
      end
    end

    context 'nickname' do
      it 'が21文字以上だと無効（skipしない場合）' do
        user.nickname = 'a' * 21
        user.skip_nickname_validation = false
        expect(user).to be_invalid
      end

      it 'が長くてもskip_nickname_validation=trueなら有効' do
        user.nickname = 'a' * 100
        user.skip_nickname_validation = true
        expect(user).to be_valid
      end
    end

    context 'self_introduction' do
      it 'が151文字だと無効' do
        user.self_introduction = 'あ' * 151
        expect(user).to be_invalid
      end
    end

    context 'driving_range_type' do
      it 'が許可されていない値だと無効' do
        user.driving_range_type = '野外'
        expect(user).to be_invalid
      end
    end

    context 'driving_range_price' do
      it 'が数値でなければ無効' do
        user.driving_range_price = 'abc'
        expect(user).to be_invalid
      end
    end

    context 'reset_password_token' do
      it 'が重複すると無効' do
        create(:user, reset_password_token: 'duplicate')
        user.reset_password_token = 'duplicate'
        expect(user).to be_invalid
      end
    end
  end

  describe 'アソシエーション' do
    context 'ユーザー削除時' do
      it '関連するpostsも削除される' do
        user = create(:user)
        create(:post, user: user)
        expect { user.destroy }.to change { Post.count }.by(-1)
      end

      it '関連するcommentsも削除される' do
        user = create(:user)
        create(:comment, user: user)
        expect { user.destroy }.to change { Comment.count }.by(-1)
      end

      it '関連するlikesも削除される' do
        user = create(:user)
        post = create(:post)
        create(:like, user: user, post: post)
        expect { user.destroy }.to change { Like.count }.by(-1)
      end
    end
  end

  describe 'Sorcery認証' do
    let!(:user) { create(:user, password: 'password', password_confirmation: 'password') }

    context '正しいパスワードを使用した場合' do
      it '認証に成功する' do
        expect(User.authenticate(user.email, 'password')).to eq(user)
      end
    end

    context '間違ったパスワードを使用した場合' do
      it '認証に失敗する' do
        expect(User.authenticate(user.email, 'wrong')).to be_nil
      end
    end
  end

  describe '#own?' do
    context '自分の投稿の場合' do
      it 'trueを返す' do
        user = create(:user)
        post = create(:post, user: user)
        expect(user.own?(post)).to be true
      end
    end

    context '他人の投稿の場合' do
      it 'falseを返す' do
        user1 = create(:user)
        user2 = create(:user)
        post = create(:post, user: user1)
        expect(user2.own?(post)).to be false
      end
    end
  end

  describe '#like, #unlike, #liked?' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    context '投稿にいいねしたとき' do
      it '#liked? が true を返す' do
        user.like(post)
        expect(user.liked?(post)).to be true
      end
    end

    context '投稿のいいねを解除したとき' do
      it '#liked? が false を返す' do
        user.like(post)
        user.unlike(post)
        expect(user.liked?(post)).to be false
      end
    end
  end
end
