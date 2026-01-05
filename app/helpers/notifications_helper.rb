module NotificationsHelper
  # 未確認の通知が1件でもあるか？
  def unchecked_notifications?
    return false unless current_user
    current_user.passive_notifications.unchecked.exists?
  end
end
