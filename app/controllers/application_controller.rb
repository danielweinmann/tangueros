class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  helper_method :namespace
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :verify_authorized, unless: -> {devise_controller? || self.class == HighVoltage::PagesController}
  after_action :verify_policy_scoped, unless: -> {devise_controller? || self.class == HighVoltage::PagesController}
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :check_profile, unless: -> {devise_controller? || self.class == HighVoltage::PagesController || action_name == 'profile_image' || action_name == 'update_profile_image' || action_name == 'location' || action_name == 'update_location' || action_name == 'roles' || action_name == 'update_roles' }
  after_action :set_x_frame_options

  def namespace
    names = self.class.to_s.split('::')
    return "null" if names.length < 2
    names[0..(names.length-2)].map(&:downcase).join('_')
  end

  def user_not_authorized(exception)
    flash[:alert] = t('flash.not_authorized')
    redirect_to(request.referrer || root_path)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
  end

  private

  def check_profile
    return unless current_user
    if current_user.follower.nil? || current_user.leader.nil?
      return redirect_to roles_users_path
    end
    unless current_user.profile_image.present? || current_user.facebook_image_url.present?
      return redirect_to profile_image_users_path
    end
    unless current_user.latitude && current_user.longitude
      return redirect_to location_users_path
    end
  end

  def set_x_frame_options
    return unless request.headers['origin'] == "https://apps.facebook.com"
    response.headers["X-Frame-Options"] = "GOFORIT"
  end
end
