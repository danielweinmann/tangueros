class LovesController < ApplicationController
  before_action :authenticate_user!, except: %i[]
  before_action :set_love, only: %i[destroy]
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]

  def index
    @loves = policy_scope(Love).visible.order("created_at DESC").page(params[:page])
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

  def destroy
    authorize @love
    @love.destroy
    redirect_to loves_url, notice: "Successfully unloved #{@love.loved_user.full_name}!"
  end

  private

  def set_love
    @love = Love.find(params[:id])
  end

  def love_params
    params.require(:love).permit(:loved_user_id)
  end
end
