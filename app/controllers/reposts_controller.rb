class RepostsController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    @pin.reposts.find_or_create_by!(user_uid: current_user.uid)
    redirect_to pin_path(@pin.uid), notice: "Reposted!"
  end

  def destroy
    @pin.reposts.find_by(user_uid: current_user.uid)&.destroy
    redirect_to pin_path(@pin.uid), notice: "Repost removed."
  end

  private

  def set_pin
    uid = params[:pin_uid]   
    @pin = Pin.find_by(uid: uid)
    redirect_to pins_path, alert: "Pin not found" if @pin.nil?
  end
end
