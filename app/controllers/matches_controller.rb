class MatchesController < ApplicationController
  before_action :authenticate_user!, except: %i[]
  before_action :set_match, only: %i[show]
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]

  def index
    @matches = policy_scope(Match).visible.order("created_at DESC").page(params[:page])
  end

  def show
    authorize @match
    @user = @match.other_user(current_user)
    @messages = @match.messages
    @message = Message.new(from_user: current_user, to_user: @user, match: @match)
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end
end
