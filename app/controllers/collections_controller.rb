class CollectionsController < ApplicationController
  before_action :require_login
  before_action :set_collection, only: [:show, :destroy, :edit, :update, :remove_pin]

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

  # NEW — EDIT COLLECTION NAME
  def edit
  end

  def update
    if @collection.update(name: params[:collection][:name])
      redirect_to collection_path(@collection), notice: "Collection renamed!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Saved page
  def saved
    @collections = current_user.collections.includes(:saved_pins, :pins)
  end

  # DELETE ENTIRE COLLECTION
  def destroy
    @collection.destroy
    redirect_to saved_path, notice: "Collection deleted."
  end

  # NEW — REMOVE PIN FROM COLLECTION
  def remove_pin
    saved_pin = @collection.saved_pins.find_by(id: params[:saved_pin_id])
    saved_pin&.destroy

    redirect_to collection_path(@collection), notice: "Pin removed."
  end

  private

  def set_collection
    @collection = current_user.collections.find_by(id: params[:id])
    redirect_to saved_path, alert: "Collection not found" unless @collection
  end
end
