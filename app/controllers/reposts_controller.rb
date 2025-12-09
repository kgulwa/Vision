class RepostsController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    current_user.reposts.find_or_create_by(pin: @pin)

    # Notify pin owner (unless reposting your own pin)
    if @pin.user.uid != current_user.uid   
      Notification.create!(
        user: @pin.user,
        actor: current_user,
        action: "reposted your post",
        notifiable: @pin,
        read: false
      )
    end

    # Notify tagged users (except the actor)
    @pin.tagged_users.each do |tagged|
      next if tagged.id == current_user.id

      Notification.create!(
        user: tagged,
        actor: current_user,
        action: "reposted a post you're tagged in",
        notifiable: @pin,
        read: false
      )
    end

    redirect_to @pin, notice: "Pin reposted!"
  end

  def destroy
    current_user.reposts.where(pin: @pin).destroy_all
    redirect_to @pin, notice: "Repost removed."
  end

  private

  def set_pin
    @pin = Pin.find_by(id: params[:pin_id] || params[:id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end
end
