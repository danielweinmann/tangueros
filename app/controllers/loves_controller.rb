class LovesController < ApplicationController
  before_action :authenticate_user!, except: %i[]
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]

  def index
    @loves = policy_scope(Love).order(:created_at)
  end

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
