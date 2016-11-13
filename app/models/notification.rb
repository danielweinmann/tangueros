class Notification < ApplicationRecord
  validates :user, presence: true
  validates :content, presence: true
  validates :email_subject, presence: true
  belongs_to :user
  belongs_to :triggering_user, class_name: "User", optional: true
  belongs_to :love, optional: true
  belongs_to :match, optional: true
  belongs_to :message, optional: true
  paginates_per 10

  after_create do
    if self.user.active?
      SendNotificationJob.set(wait: 2.seconds).perform_later(self)
      NotificationMailer.notification(self).deliver_later(wait: 2.seconds)
    end
  end

  def self.unread
    where("read = false")
  end

  def self.visible
    joins(:triggering_user).where({users: {active: true}})
  end

  def show_triggering_user?
    self.match.present? || self.message.present?
  end
end
