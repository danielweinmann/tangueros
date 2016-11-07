class FacebookCanvasController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[]
  after_action :set_frame_header
  skip_before_action :verify_authenticity_token

  def index
  end

  private

  def set_frame_header
    response.headers["X-Frame-Options"] = "GOFORIT"
  end
end
