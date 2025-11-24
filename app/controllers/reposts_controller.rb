class RepostsController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    @pin.reposts.find_or_create_by!(user_id: current_user.id)
    redirect_to pin_path(@pin.id), notice: "Reposted!"
  end

  def destroy
    @pin.reposts.find_by(user_id: current_user.id)&.destroy
    redirect_to pin_path(@pin.id), notice: "Repost removed."
  end

  private

  def set_pin
    @pin = Pin.find_by(id: params[:pin_id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end
end
