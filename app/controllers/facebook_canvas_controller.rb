class FacebookCanvasController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  after_action :verify_authorized, except: %i[index show]
  after_action :verify_policy_scoped, only: %i[]
  skip_before_action :verify_authenticity_token

  def index
    redirect_to :root
  end

  def show
    return redirect_to notifications_path if current_user
    @notification = Notification.find(params[:id])
  end
end
