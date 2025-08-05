require 'rails_helper'

RSpec.describe ScoreRecord, type: :model do
  it '有効な要素を持つ' do
    expect(build(:score_record)).to be_valid
  end

  it 'course_nameが必要' do
    record = build(:score_record, course_name: nil)
    expect(record).to be_invalid
    expect(record.errors[:course_name]).to include("を入力してください")
  end

  it 'scoreが正しい数値でなければ無効' do
    record = build(:score_record, score: 'aaa' )
    expect(record).to be_invalid
    expect(record.errors[:score]).to include("は数値で入力してください")
  end
end
