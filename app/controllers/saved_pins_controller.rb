class SavedPinsController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    if params[:collection_id].present?
      collection = current_user.collections.find_by(id: params[:collection_id])
    elsif params[:new_collection_name].present?
      collection = current_user.collections.create!(name: params[:new_collection_name])
    else
      collection = current_user.collections.find_or_create_by!(name: "Default")
    end

    saved = SavedPin.find_or_create_by!(
      pin_id: @pin.id,
      collection_id: collection.id,
      user_id: current_user.id
    )

    # 🔔 Notify pin owner their post was saved
    if @pin.user_id != current_user.id
      Notification.create!(
        user: @pin.user,
        actor: current_user,
        action: "saved your post",
        notifiable: @pin,
        read: false
      )
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to pin_path(@pin.id), notice: "Saved to #{collection.name}!" }
    end
  end

  def destroy
    @saved_pin = SavedPin.find_by(id: params[:id])
    saved_pin_pin = @saved_pin&.pin
    @saved_pin&.destroy
    redirect_to pin_path(saved_pin_pin.id), notice: "Pin removed."
  end

  private

  def set_pin
    @pin = Pin.find_by(id: params[:pin_id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end
end
