class DismissalsController < ApplicationController
  before_action :authenticate_user!, except: %i[]
  before_action :set_user, only: %i[]
  after_action :verify_authorized, except: %i[]
  after_action :verify_policy_scoped, only: %i[]

  def create
    @dismissal = Dismissal.new(dismissal_params)
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
