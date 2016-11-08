class SendFacebookInviteNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    return unless user
    user.send_facebook_notification("Are you enjoying Tangueros? Invite your friends and you'll enjoy it even more!", "invite")
  end
end
