class SendFacebookNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    return unless notification
    user = notification.user
    return unless user.provider == 'facebook' && user.uid.present?
    graph = Koala::Facebook::API.new(Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']).get_app_access_token)
    response = graph.put_connections(user.uid, "notifications", template: notification.facebook_content, href: notification.id)
  end
end
