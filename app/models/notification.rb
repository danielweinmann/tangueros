class Notification < ApplicationRecord
  validates :user, presence: true
  validates :content, presence: true
  validates :email_subject, presence: true
  belongs_to :user
  belongs_to :triggering_user, class_name: "User", optional: true
  belongs_to :love, optional: true
  belongs_to :match, optional: true

  def self.unread
    where("read = false")
  end
end
