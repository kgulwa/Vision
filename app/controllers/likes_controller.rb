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
    @pin = Pin.find_by(id: params[:pin_id] || params[:id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end
end
