class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :set_user, only: %i[]
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[]

  def index
  end

  def profile_image
    @user = current_user
    authorize @user
  end

  def update_profile_image
    @user = current_user
    authorize @user
    if !params[:user]
      @user.errors.add(:profile_image, "must be selected")
      return render :profile_image
    end
    if @user.update(user_params)
      redirect_to profile_image_users_path, notice: "Profile picture successfully uploaded."
    else
      render :profile_image
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:profile_image)
    end
end
