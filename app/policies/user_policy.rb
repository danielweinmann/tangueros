class UserPolicy < ApplicationPolicy
  def show?
    true
  end

  def roles?
    user
  end

  def update_roles?
    user
  end

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

  def radius?
    user
  end

  def update_radius?
    user
  end

  def deactivate?
    user
  end

  def reactivate?
    user
  end

  def update_active?
    user
  end

  def invite?
    true
  end
end
