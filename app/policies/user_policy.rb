class UserPolicy < ApplicationPolicy
  def profile_image?
    user
  end

  def update_profile_image?
    user
  end

  def location?
    user
  end

  def update_location?
    user
  end
end
