class Message < ApplicationRecord
  belongs_to :from_user, class_name: "User"
  belongs_to :to_user, class_name: "User"
  belongs_to :match
  validates :from_user, presence: true
  validates :to_user, presence: true
  validates :match, presence: true
  validates :content, presence: true
  validate :users_must_match, :must_not_send_to_yourself
  paginates_per 10

  after_create do
    Notification.create({
      user: self.to_user,
      triggering_user: self.from_user,
      message: self,
      content: "#{self.from_user.full_name} sent you a message. Check it out!",
      email_subject: "#{self.from_user.full_name} sent you a message on Tangueros 💌",
      email_content: "#{self.from_user.full_name} sent you a message on Tangueros. <a href='https://tangueros.club/matches/#{self.match.id}'>Click here</a> to read it 😀",
      push_subject: "#{self.from_user.full_name} sent you a message",
      push_content: "Check it out!",
      facebook_content: "#{self.from_user.full_name} sent you a message on Tangueros. Check it out!",
    })
  end

  private

  def users_must_match
    unless self.from_user.does_match?(self.to_user)
      errors.add(:to_user, "must be your match")
    end
  end

  def must_not_send_to_yourself
    if self.from_user == self.to_user
      errors.add(:to_user, "must not be yourself")
    end
  end
end
