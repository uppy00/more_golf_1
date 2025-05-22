%w[スコア記録 練習記録 質問 その他].each do |tag_name|
  Tag.find_or_create_by!(name: tag_name)
end
