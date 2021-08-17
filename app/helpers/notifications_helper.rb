module NotificationsHelper
  def get_content notification
    "noti." + notification.noti_type
  end
end
