FactoryBot.define do
  factory :post do
    title { "テストタイトル" }
    body { "テスト本文" }
    image { nil }
    video { nil }

    association :user
    association :tag, factory: :tag

    trait :with_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/post_sample.jpg'), 'image/jpeg') }
    end

    trait :with_video do
      video { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/post_sample.mp4'), 'video/mp4') }
    end

    trait :with_score_record do
      association :postable, factory: :score_record
    end

    trait :with_practice_record do
      association :postable, factory: :practice_record
    end
  end
end
