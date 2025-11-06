class LikesController < ApplicationController
  before_action :require_login

  def create
    @pin = Pin.find(params[:pin_id])
    current_user.like(@pin)
    redirect_to @pin, notice: "Pin liked!"
  end

  def destroy
    @pin = Pin.find(params[:pin_id])
    current_user.unlike(@pin)
    redirect_to @pin, notice: "Pin unliked!"
  end

  private

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "You must be logged in to like pins."
    end
  end
end