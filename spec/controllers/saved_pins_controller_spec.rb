class SavedPinsController < ApplicationController
  before_action :require_login
  before_action :set_pin

  def create
    # Determine which collection to use
    if params[:collection_id].present?
      collection = current_user.collections.find_by(id: params[:collection_id])

      # If the given ID does not belong to the user, raise an error for clean test coverage
      raise ActiveRecord::RecordInvalid.new(SavedPin.new), "Invalid collection" if collection.nil?

    elsif params[:new_collection_name].present?
      collection = current_user.collections.create!(name: params[:new_collection_name])

    else
      collection = current_user.collections.find_or_create_by!(name: "Default")
    end

    # Create or find the saved pin
    saved = SavedPin.find_or_create_by!(
      pin_id: @pin.id,
      collection_id: collection.id,
      user_id: current_user.id
    )

    # Notify pin owner if someone else saved it
    if @pin.user != current_user
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

    # If saved pin does not exist → redirect based on pin_id from params
    if @saved_pin.nil?
      return redirect_to pin_path(params[:pin_id]), notice: "Pin removed."
    end

    pin = @saved_pin.pin
    @saved_pin.destroy

    redirect_to pin_path(pin.id), notice: "Pin removed."
  end

  private

  def set_pin
    # Accept id as string or integer
    @pin = Pin.find_by(id: params[:pin_id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end
end
