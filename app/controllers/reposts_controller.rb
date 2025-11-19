class RepostsController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    @pin.reposts.create(user_uid: current_user.uid)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @pin.reposts.find_by(user_uid: current_user.uid)&.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_pin
    @pin = Pin.find(params[:pin_id])
  end
end
