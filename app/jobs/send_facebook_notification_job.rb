class SendFacebookNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    return unless notification
    user = notification.user
    user.send_facebook_notification(notification.facebook_content, notification.id)
  end
end
