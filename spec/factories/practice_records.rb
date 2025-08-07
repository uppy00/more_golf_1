FactoryBot.define do
  factory :practice_record do
    driving_range_name { "テスト練習場" }
    practice_hour { 30 }
    ball_count { 150 }
    effort_focus { "テスト意識したこと" }
    video_reference { "テスト参考ビデオ" }
  end
end
