class Dismissal < ApplicationRecord
  belongs_to :user
  belongs_to :dismissed_user, class_name: "User"
end
