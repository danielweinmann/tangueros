class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  helper_method :namespace
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :verify_authorized, unless: -> {devise_controller? || self.class == HighVoltage::PagesController}
  after_action :verify_policy_scoped, unless: -> {devise_controller? || self.class == HighVoltage::PagesController}
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :check_profile, unless: -> {devise_controller? || action_name == 'profile_image' || action_name == 'update_profile_image' }

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
    unless current_user.profile_image.present? || current_user.facebook_image_url.present?
      return redirect_to profile_image_users_path
    end
  end

end
