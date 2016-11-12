class DismissalsController < ApplicationController
  before_action :authenticate_user!, except: %i[]
  after_action :verify_authorized, except: %i[]
  after_action :verify_policy_scoped, only: %i[]

  def create
    @dismissal = Dismissal.where(user: current_user, dismissed_user: dismissal_params[:dismissed_user_id]).first
    if @dismissal
      @dismissal.updated_at = Time.now
    else
      @dismissal = Dismissal.new(dismissal_params)
    end
    @dismissal.user = current_user
    authorize @dismissal

    if @dismissal.save
      redirect_to :root
    else
      flash[:failure] = "Ooops. There was a problem with your request. Please try again."
      redirect_to :root
    end
  end

  private

  def dismissal_params
    params.require(:dismissal).permit(:dismissed_user_id)
  end
end
