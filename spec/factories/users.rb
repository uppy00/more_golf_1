FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    nickname   { Faker::Internet.username(specifier: 3..20) }
    email      { Faker::Internet.unique.email }
    password   { 'password' }
    password_confirmation { 'password' }
    self_introduction { 'テスト自己紹介' }
    favorite_course { 'テストゴルフクラブ' }
    favorite_driving_range { 'テスト練習場' }
    driving_range_type { '打ち放題' }
    driving_range_price { 1200 }
    best_score { 78 }
    best_score_course { 'ベストテストコース' }
    favorite_video_creator { 'テストテラユー' }
    prefecture_id { '13' } # ActiveHash用
    skip_nickname_validation { false }

    # CarrierWaveのテスト用ダミー画像（spec/fixtures/files/avatar.jpgを用意）
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/avatar.jpg'), 'image/jpeg') }
  end
end
