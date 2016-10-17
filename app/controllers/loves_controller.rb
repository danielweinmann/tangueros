class LovesController < ApplicationController
  before_action :authenticate_user!, except: %i[]
  before_action :set_user, only: %i[]
  after_action :verify_authorized, except: %i[]
  after_action :verify_policy_scoped, only: %i[]

  def create
    @love = Love.new(love_params)
    @love.user = current_user
    authorize @love

    if @love.save
      redirect_to :root
    else
      flash[:failure] = "Ooops. There was a problem with your request. Please try again."
      redirect_to :root
    end
  end

  private

  def love_params
    params.require(:love).permit(:loved_user_id)
  end
end
