FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    nickname   { Faker::Internet.username(specifier: 3..20) }
    email      { Faker::Internet.unique.email }
    password   { 'password' }
    password_confirmation { 'password' }
    self_introduction { Faker::Lorem.sentence(word_count: 10) }
    favorite_course { Faker::Lorem.characters(number: 10) }
    favorite_driving_range { Faker::Lorem.characters(number: 10) }
    driving_range_type { %w[打ち放題 球数 インドア].sample }
    driving_range_price { Faker::Number.between(from: 500, to: 5000) }
    best_score { Faker::Number.between(from: 60, to: 150) }
    best_score_course { Faker::Lorem.characters(number: 15) }
    favorite_video_creator { Faker::Name.first_name }
    prefecture_id { Faker::Number.between(from: 1, to: 47) } # ActiveHash用
    skip_nickname_validation { false }

    # CarrierWaveのテスト用ダミー画像（spec/fixtures/files/avatar.jpgを用意）
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/avatar.jpg'), 'image/jpeg') }
  end
end
