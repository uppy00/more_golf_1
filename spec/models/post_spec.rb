require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  
  describe 'ポリモーフィック関連の内容確認' do
    context 'タグが質問、その他の場合' do
      let(:tag) { create(:tag, name: "質問") }

      it 'title,bodyが存在すれば有効' do
        post = build(:post, user: user, tag: tag, title: "タイトル", body: "本文")
        expect(post).to be_valid
      end

      it 'bodyがないと無効' do
        post = build(:post, user: user, tag: tag, body: nil)
        expect(post).to be_invalid
        expect(post.errors[:body]).to include("を入力してください")
      
      end
    end

    context 'タグが練習記録の場合' do
      let(:tag) {create(:tag, name: "練習記録") }

      it 'postableがpractece_recordの場合、必要な属性を持つ' do
        post = build(:post, :with_practice_record, tag: tag, user: user)

        # postにbodyがなくても有効
        post.body = nil
        expect(post).to be_valid

        # postableに正しい属性があるか
        expect(post.postable).to be_a(PracticeRecord)
        expect(post.postable.practice_hour).to be_present
        expect(post.postable.ball_count).to be_present
      end
    end

    context 'タグがスコア記録の場合' do
      let(:tag) {create(:tag, name: "スコア記録") }

      it 'postableがscore_recordの場合、必要な属性を持つ' do
        post = build(:post, :with_score_record, tag: tag, user: user)

        expect(post).to be_valid

        # postableに正しい属性があるか
        expect(post.postable).to be_a(ScoreRecord)
        expect(post.postable.course_name).to be_present
        expect(post.postable.score).to be_present
      end
    end
  end
end
