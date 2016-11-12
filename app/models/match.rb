class Match < ApplicationRecord
  belongs_to :user
  belongs_to :matched_user, class_name: "User"

  after_create do
    [self.user, self.matched_user].each do |user|
      triggering_user = (user == self.user ? self.matched_user : self.user)
      Notification.create({
        user: user,
        triggering_user: triggering_user,
        match: self,
        content: "<b>#{triggering_user.full_name}</b> loooves to dance with you! You are a match 🙌",
        email_subject: "You have a match on Tangueros 🙌",
        email_content: "You have a match on Tangueros! Want to find out who it is? <a href='https://tangueros.club'>Click here</a> and we'll stop the suspense 😀",
        push_subject: "You have a match",
        push_content: "Find out who it is!",
        facebook_content: "You have a match on Tangueros! Find out who it is!",
      })
    end
  end

  def self.visible
    joins(:user).joins(:matched_user).where({users: {active: true}, matched_users_matches: {active: true}})
  end
end
