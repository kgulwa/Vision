class CollectionsController < ApplicationController
  before_action :require_login
  before_action :set_collection, only: [:show, :destroy]

  def create
    @collection = current_user.collections.create!(name: params[:name])

    # Save pin into this NEW collection (if triggered from save modal)
    if params[:pin_uid].present?
      SavedPin.create!(
        user_uid: current_user.uid,
        pin_uid: params[:pin_uid],
        collection_uid: @collection.uid
      )
    end

    redirect_to collection_path(@collection.uid), notice: "Collection created!"
  end

  def show
    # Show only current user's saved pins
    @saved_pins = @collection.saved_pins.includes(:pin)
  end

  def destroy
    @collection.destroy
    redirect_to collections_path, notice: "Collection deleted."
  end

  private

  def set_collection
    uid = params[:uid] || params[:id]
    @collection = current_user.collections.find_by(uid: uid)

    redirect_to collections_path, alert: "Collection not found" if @collection.nil?
  end

  def require_login
    redirect_to login_path unless logged_in?
  end
end
