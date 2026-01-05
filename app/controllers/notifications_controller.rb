class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.includes(:visitor, :post, :comment).limit(50)
    current_user.passive_notifications.where(checked: false).update_all(checked: true)
  end
end
