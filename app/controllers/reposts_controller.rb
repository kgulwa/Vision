class RepostsController < ApplicationController
  before_action :require_login # optional, if you have authentication

  def create
    pin = Pin.find(params[:pin_id])
    pin.reposts.create(user: current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    pin = Pin.find(params[:pin_id])
    pin.reposts.find_by(user: current_user)&.destroy
    redirect_back(fallback_location: root_path)
  end
end
