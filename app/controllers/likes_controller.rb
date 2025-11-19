class LikesController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    current_user.like(@pin)
    redirect_to @pin, notice: "Pin liked!"
  end

  def destroy
    current_user.unlike(@pin)
    redirect_to @pin, notice: "Pin unliked!"
  end

  private

  def set_pin
    @pin = Pin.find(params[:pin_id])
  end

  def require_login
    redirect_to login_path, alert: "You must be logged in to like pins." unless logged_in?
  end
end
