class NotificationsController < ApplicationController
  before_action :authenticate_user!, except: %i[]
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]

  def index
    @notifications = policy_scope(Notification).order(created_at: :desc)
  end
end
