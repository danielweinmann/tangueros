class Love < ApplicationRecord
  belongs_to :user
  belongs_to :loved_user, class_name: "User"

  after_create do
    if Love.where(user: self.loved_user, loved_user: self.user).count > 0
      return if Match.where(user: self.user, matched_user: self.loved_user).count > 0
      Match.create!(user: self.user, matched_user: self.loved_user)
    end
  end
end
