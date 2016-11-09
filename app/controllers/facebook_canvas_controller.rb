class FacebookCanvasController < ApplicationController
  before_action :authenticate_user!, only: %i[]
  after_action :verify_authorized, only: %i[]
  after_action :verify_policy_scoped, only: %i[]
  skip_before_action :verify_authenticity_token

  def index
  end

  def invite
  end

  def show
    @notification = Notification.find(params[:id])
  end
end
