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
    uid = params[:pin_uid] || params[:uid]
    @pin = Pin.find_by(uid: uid)
    redirect_to pins_path, alert: "Pin not found" if @pin.nil?
  end
end
