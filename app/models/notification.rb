class Notification < ApplicationRecord
  validates :user, presence: true
  validates :content, presence: true
  validates :email_subject, presence: true
  belongs_to :user
  belongs_to :triggering_user, class_name: "User", optional: true
  belongs_to :love, optional: true
  belongs_to :match, optional: true

  after_create do
    SendNotificationJob.set(wait: 2.seconds).perform_later(self)
    NotificationMailer.notification(self).deliver_later(wait: 2.seconds)
  end

  def self.unread
    where("read = false")
  end
end
