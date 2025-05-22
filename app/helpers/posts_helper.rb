module PostsHelper
  def tag_color_class(tag_name)
    case tag_name
    when "スコア記録" then "bg-green-500"
    when "練習記録" then "bg-blue-500"
    when "質問" then "bg-yellow-500"
    when "その他" then "bg-gray-500"
    end
  end
end
