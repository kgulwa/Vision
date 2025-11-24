class SavedPinsController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    # Choose collection
    if params[:collection_uid].present?
      collection = current_user.collections.find_by(uid: params[:collection_uid])

    elsif params[:new_collection_name].present?
      collection = current_user.collections.create!(name: params[:new_collection_name])

    else
      collection = current_user.collections.find_or_create_by!(name: "Default")
    end

    SavedPin.find_or_create_by!(
      pin_uid: @pin.uid,
      collection_uid: collection.uid,
      user_uid: current_user.uid
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to pin_path(@pin.uid), notice: "Saved to #{collection.name}!" }
    end
  end

  def destroy
    @saved_pin = SavedPin.find_by(uid: params[:uid])
    @saved_pin&.destroy
    redirect_to pin_path(@saved_pin.pin_uid), notice: "Pin removed."
  end

  private

  def set_pin
    uid = params[:pin_uid] # The route ensures this is present
    @pin = Pin.find_by(uid: uid)
    redirect_to pins_path, alert: "Pin not found" if @pin.nil?
  end
end
