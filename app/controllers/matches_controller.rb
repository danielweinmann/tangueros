class MatchesController < ApplicationController
  before_action :authenticate_user!, except: %i[]
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]

  def index
    @matches = policy_scope(Match).visible.order("created_at DESC").page(params[:page])
  end
end
