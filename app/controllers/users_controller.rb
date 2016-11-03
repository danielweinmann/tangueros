class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_user, only: %i[show]
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[]

  def index
    if current_user && current_user.latitude && current_user.longitude
      @user = User
        .visible
        .where("id <> #{current_user.id}")
        .with_roles_prefered_by(current_user)
        .not_loved_by(current_user)
        .not_dismissed_by(current_user)
        .near([current_user.latitude, current_user.longitude], 41000, units: :km)
        .limit(1).first
      if @user
        @love = Love.new(loved_user: @user)
        @dismissal = Dismissal.new(dismissed_user: @user)
      end
    end
  end

  def show
    authorize @user
    @lovers_count = @user.lovers.count
    @matches_count = @user.matches.count
    @love = Love.new(loved_user: @user)
    @dismissal = Dismissal.new(dismissed_user: @user)
  end

  def roles
    @user = current_user
    authorize @user
    # Had to add this line for turbolinks redirect to work.
    response.headers['Turbolinks-Location'] = roles_users_path
  end

  def update_roles
    @user = current_user
    authorize @user
    if !params[:user]
      @user.errors.add(:role, "must be selected")
      return render :roles
    end
    if @user.update(user_params)
      redirect_to :root, notice: "Your role was successfully defined!"
    else
      render :roles
    end
  end

  def profile_image
    @user = current_user
    authorize @user
    # Had to add this line for turbolinks redirect to work.
    response.headers['Turbolinks-Location'] = profile_image_users_path
  end

  def update_profile_image
    @user = current_user
    authorize @user
    if !params[:user]
      @user.errors.add(:profile_image, "must be selected")
      return render :profile_image
    end
    if @user.update(user_params)
      redirect_to :root, notice: "Profile picture successfully uploaded."
    else
      render :profile_image
    end
  end

  def location
    @user = current_user
    authorize @user
    # Had to add this line for turbolinks redirect to work.
    response.headers['Turbolinks-Location'] = location_users_path
  end

  def update_location
    @user = current_user
    authorize @user
    if !params[:user]
      @user.errors.add(:latitude, "must be selected")
      @user.errors.add(:longitude, "must be selected")
      return render :location
    end
    if @user.update(user_params)
      redirect_to :root, notice: "Your location was successfully defined!"
    else
      render :location
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:profile_image, :latitude, :longitude, :follower, :leader)
    end
end
