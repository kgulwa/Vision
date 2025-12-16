class SavedPinsController < ApplicationController
  before_action :require_login
  before_action :set_pin, only: [:create]

  def create
    @saved_pin = SavedPins::Create.call(
      user: current_user,
      pin: @pin,
      collection_id: params[:collection_id],
      new_collection_name: params[:new_collection_name]
    )

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to pin_path(@pin),
                    notice: "Saved to #{@saved_pin.collection.name}!"
      end
    end
  end

  def destroy
    pin = SavedPins::Destroy.call(saved_pin_id: params[:id])
    redirect_to pin_path(pin), notice: "Pin removed."
  end

  private

  def set_pin
    @pin = Pin.find_by(id: params[:pin_id])
    redirect_to pins_path, alert: "Pin not found" unless @pin
  end
end
