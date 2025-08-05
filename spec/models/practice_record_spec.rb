require 'rails_helper'

RSpec.describe PracticeRecord, type: :model do
  it '有効なファクトリを持つ' do
    expect(build(:practice_record)).to be_valid
  end

  it 'driving_range_nameが必須' do
    record = build(:practice_record, driving_range_name: nil)
    expect(record).to be_invalid
    expect(record.errors[:driving_range_name]).to include("を入力してください")
  end

  it 'practice_hourが整数でなければ無効' do
    record = build(:practice_record, practice_hour: 'abc')
    expect(record).to be_invalid
    expect(record.errors[:practice_hour]).to include("は数値で入力してください")
  end

  it 'ball_countが負の数なら無効' do
    record = build(:practice_record, ball_count: -10)
    expect(record).to be_invalid
    expect(record.errors[:ball_count]).to include("は0以上の値にしてください")
  end
end

