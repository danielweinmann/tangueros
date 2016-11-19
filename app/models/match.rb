class Match < ApplicationRecord
  belongs_to :user
  belongs_to :matched_user, class_name: "User"
  has_many :notifications, dependent: :destroy
  has_many :messages, dependent: :nullify

  after_create do
    [self.user, self.matched_user].each do |user|
      triggering_user = (user == self.user ? self.matched_user : self.user)
      Notification.create({
        user: user,
        triggering_user: triggering_user,
        match: self,
        content: "<b>#{triggering_user.full_name}</b> loooves to dance with you! You are a match 🙌",
        email_subject: "You have a match on Tangueros 🙌",
        email_content: "You have a match on Tangueros! Want to find out who it is? <a href='https://tangueros.club/notifications'>Click here</a> and we'll end the suspense 😀",
        push_subject: "You have a match",
        push_content: "Find out who it is!",
        facebook_content: "You have a match on Tangueros! Find out who it is!",
      })
    end
  end

  def self.visible
    joins(:user).joins(:matched_user).where({users: {active: true}, matched_users_matches: {active: true}})
  end

  def self.between_users(user, matched_user)
    Match.where("(user_id = #{user.id} AND matched_user_id = #{matched_user.id}) OR (user_id = #{matched_user.id} AND matched_user_id = #{user.id})").first
  end

  def messages
    Message.where("(from_user_id = #{self.user_id} AND to_user_id = #{self.matched_user_id}) OR (from_user_id = #{self.matched_user_id} AND to_user_id = #{self.user_id})").order(:created_at)
  end

  def other_user(user)
    (self.user == user ? self.matched_user : self.user)
  end
end
