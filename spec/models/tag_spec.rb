require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'バリデーション' do
    it 'nameがあれば有効' do
      tag = build(:tag)
      expect(tag).to be_valid
    end

    it 'nameが空なら無効' do
      tag = build(:tag, name: '')
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include("を入力してください")
    end
  end
end

