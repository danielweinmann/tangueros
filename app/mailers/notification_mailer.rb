class NotificationMailer < ApplicationMailer
  def notification(notification)
    @notification = notification
    @user = notification.user
    mail(to: @user.to_email, subject: notification.email_subject)
  end
end
