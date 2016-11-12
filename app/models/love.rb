class Love < ApplicationRecord
  belongs_to :user
  belongs_to :loved_user, class_name: "User"

  after_create do
    if self.loved_user.does_love?(self.user)
      return if self.user.does_match?(self.loved_user)
      Match.create!(user: self.user, matched_user: self.loved_user)
    else
      Notification.create({
        user: self.loved_user,
        triggering_user: self.user,
        love: self,
        content: "Someone loooves to dance with you! Want to find out who it is?",
        email_subject: "❤️ Someone loooves to dance with you ❤️",
        email_content: "Someone loooves to dance with you! Want to find out who it is? <a href='https://tangueros.club'>Tell us</a> who you love to dance with and we'll let you know when there's a match 😀",
        push_subject: "Someone loooves to dance with you!",
        push_content: "Want to find out who it is?",
        facebook_content: "Someone loooves to dance with you! Want to find out who it is?",
      })
    end
  end

  def self.visible
    joins(:user).joins(:loved_user).where({users: {active: true}, loved_users_loves: {active: true}})
  end
end
