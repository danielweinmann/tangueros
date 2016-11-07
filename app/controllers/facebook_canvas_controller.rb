class FacebookCanvasController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[]
  skip_before_action :verify_authenticity_token
  layout "application"

  def index
    response.headers["X-Frame-Options"] = "GOFORIT"
  end
end
