class SavedPinsController < ApplicationController
  before_action :require_login

  def create
    @pin = Pin.find(params[:pin_id])

    # CASE 1 — Save to existing collection
    if params[:collection_id].present?
      collection = current_user.collections.find(params[:collection_id])

    # CASE 2 — Create new collection
    elsif params[:new_collection_name].present?
      collection = current_user.collections.create!(name: params[:new_collection_name])

    # CASE 3 — Default collection
    else
      collection = current_user.collections.find_or_create_by!(name: "Default")
    end

    saved_pin = SavedPin.find_or_create_by!(
      pin: @pin,
      collection: collection,
      user_uid: current_user.uid
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @pin, notice: "Saved to #{collection.name}!" }
    end
  end

  def destroy
    @saved_pin = SavedPin.find(params[:id])
    @saved_pin.destroy
    redirect_to @saved_pin.pin, notice: "Pin removed."
  end
end
