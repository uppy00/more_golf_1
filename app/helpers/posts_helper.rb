module PostsHelper
  def tag_color_class(tag_name)
    case tag_name
    when "スコア記録" then "bg-green-500"
    when "練習記録" then "bg-blue-500"
    when "質問" then "bg-yellow-500"
    when "その他" then "bg-gray-500"
    end
  end
  def youtube_embed_id(str)
    s = str.to_s.strip
    return "" if s.blank?

    return s if s.length == 11
    return s.split("youtu.be/").last.split("?").first if s.include?("youtu.be/")
    return s.split("v=").last.split("&").first       if s.include?("v=")
    return s.split("/shorts/").last.split("?").first if s.include?("/shorts/")

    ""
  end
end
