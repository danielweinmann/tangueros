class UserPolicy < ApplicationPolicy
  def profile_image?
    user
  end

  def update_profile_image?
    user
  end
end
