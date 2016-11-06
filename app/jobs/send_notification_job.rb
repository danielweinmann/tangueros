class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    SendFacebookNotificationJob.perform_later(notification)
  end
end
