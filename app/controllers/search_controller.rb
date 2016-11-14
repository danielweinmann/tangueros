class SearchController < ApplicationController
  before_action :authenticate_user!, except: %i[]
  after_action :verify_authorized, except: %i[]
  after_action :verify_policy_scoped, only: %i[]

  def index
    authorize current_user
    return @users = [] unless params[:query]
    @users = User
      .visible 
      .where("id <> #{current_user.id}")
      .search(params[:query])
      .near([current_user.latitude, current_user.longitude], current_user.radius, units: :km)
      .page(params[:page])
  end
end
