class MessagesController < ApplicationController
  before_action :authenticate_user!, except: %i[]
  after_action :verify_authorized, except: %i[]
  after_action :verify_policy_scoped, only: %i[]

  def create
    @message = Message.new(message_params)
    @message.from_user = current_user
    authorize @message
    unless @message.save
      flash[:failure] = "Ooops. There was a problem with your request. Please try again."
    end
    redirect_to @message.match
  end

  private

  def message_params
    params.require(:message).permit(:to_user_id, :match_id, :content)
  end
end
