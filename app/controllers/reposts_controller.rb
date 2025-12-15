class RepostsController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    Reposts::Create.call(user: current_user, pin: @pin)
    redirect_to @pin, notice: "Pin reposted!"
  end

  def destroy
    Reposts::Destroy.call(user: current_user, pin: @pin)
    redirect_to @pin, notice: "Repost removed."
  end

  private

  def set_pin
    @pin = Pin.find_by(id: params[:pin_id] || params[:id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end
end
