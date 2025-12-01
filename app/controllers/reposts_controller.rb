class RepostsController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    @pin.reposts.find_or_create_by!(user_id: current_user.id)

    #  Notify pin owner (unless reposting your own pin)
    if @pin.user_id != current_user.id
      Notification.create!(
        user: @pin.user,
        actor: current_user,
        action: "reposted your pin",
        notifiable: @pin,
        read: false
      )
    end

    #  Notify ALL tagged users (except reposting user + owner)
    @pin.tagged_users.each do |tagged|
      next if tagged.id == current_user.id
      next if tagged.id == @pin.user_id

      Notification.create!(
        user: tagged,
        actor: current_user,
        action: "reposted a post you're tagged in",
        notifiable: @pin,
        read: false
      )
    end

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
