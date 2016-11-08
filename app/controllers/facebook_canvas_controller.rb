class FacebookCanvasController < ApplicationController
  before_action :authenticate_user!, only: %i[]
  after_action :verify_authorized, only: %i[]
  after_action :verify_policy_scoped, only: %i[]
  skip_before_action :verify_authenticity_token

  def index
    redirect_to :root
  end

  def invite
    redirect_to invite_users_path
  end

  def show
    return redirect_to notifications_path if current_user
    @notification = Notification.find(params[:id])
  end
end
