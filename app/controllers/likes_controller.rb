class LikesController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    current_user.like(@pin)

    # Notify pin owner (unless liking own pin)
    if @pin.user_id != current_user.id
      Notification.create!(
        user: @pin.user,
        actor: current_user,
        action: "liked your post",
        notifiable: @pin,
        read: false
      )
    end

    #  Notify ALL tagged users (except the actor)
    @pin.tagged_users.each do |tagged|
      next if tagged.id == current_user.id

      Notification.create!(
        user: tagged,
        actor: current_user,
        action: "liked a post you're tagged in",
        notifiable: @pin,
        read: false
      )
    end

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
