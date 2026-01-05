FactoryBot.define do
  factory :notification do
    visitor_id { "" }
    visited_id { "" }
    post { nil }
    comment { nil }
    action { "MyString" }
    checked { false }
  end
end
