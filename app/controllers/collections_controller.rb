class CollectionsController < ApplicationController
  before_action :require_login
  before_action :set_collection, only: [:show, :destroy]

  def create
    @collection = current_user.collections.create!(name: params[:name])

    if params[:pin_id].present?
      SavedPin.create!(
        user_id: current_user.id,
        pin_id: params[:pin_id],
        collection_id: @collection.id
      )
    end

    redirect_to collection_path(@collection.id), notice: "Collection created!"
  end

  def show
    @saved_pins = @collection.saved_pins.includes(:pin)
  end

  # NEW: Saved page
  def saved
    @collections = current_user.collections.includes(:saved_pins, :pins)
  end

  def destroy
    @collection.destroy
    redirect_to saved_path, notice: "Collection deleted."
  end

  private

  def set_collection
    @collection = current_user.collections.find_by(id: params[:id])
    redirect_to saved_path, alert: "Collection not found" unless @collection
  end
end
